defmodule DagsterPipes.Context do
  @moduledoc """
  The context of the Dagster Pipes process.
  """

  use GenServer

  defstruct [
    :context_data,
    :message_channel,
    materialized_assets: MapSet.new(),
    closed?: false
  ]

  ## APIs

  @doc """
  Create and initialize the pipes connection.
  """
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  @doc """
  Closes the pipes connection.
  """
  def close(context, exception \\ nil, stacktrace \\ []) do
    result = GenServer.call(context, {:close, exception, stacktrace})
    GenServer.stop(context)
    result
  end

  @doc """
  A key-value map for all extras provided by the user.
  """
  def extras(context) do
    context_data = GenServer.call(context, :context_data)
    context_data.extras
  end

  @doc """
  The partition key for the currently scoped partition.
  """
  def partition_key(context) do
    context_data = GenServer.call(context, :context_data)
    context_data.partition_key
  end

  @doc """
  The job name for the currently executing run.
  """
  def job_name(context) do
    context_data = GenServer.call(context, :context_data)
    context_data.job_name
  end

  @doc """
  Report to the Dagster that asset is materialized.
  """
  def report_asset_materialization(
        context,
        metadata \\ nil,
        data_version \\ nil,
        asset_key \\ nil
      )
      when is_map(metadata) do
    GenServer.call(context, {:report_asset_materialization, metadata, data_version, asset_key})
  end

  @doc """
  Report to the Dagster that an asset check has been performed.
  """
  def report_asset_check(
        context,
        check_name,
        passed,
        severity \\ :ERROR,
        metadata \\ nil,
        asset_key \\ nil
      )
      when is_binary(check_name) and is_boolean(passed) and severity in [:WARN, :ERROR] do
    GenServer.call(
      context,
      {:report_asset_check, check_name, passed, severity, metadata, asset_key}
    )
  end

  @doc """
  Send a JSON serializable payload back to the orchestration process.
  """
  def report_custom_message(context, payload) do
    GenServer.call(context, {:report_custom_message, payload})
  end

  ## Callbacks

  @impl GenServer
  def init(args) do
    {:ok, %__MODULE__{}, {:continue, args}}
  end

  @impl GenServer
  def handle_continue(args, context) do
    params_loader = Keyword.fetch!(args, :params_loader)
    context_loader = Keyword.fetch!(args, :context_loader)
    message_writer = Keyword.fetch!(args, :message_writer)

    # Initialize context
    context_params = DagsterPipes.ParamsLoader.Protocol.load_context_params!(params_loader)
    context_data = DagsterPipes.ContextLoader.load_context(context_loader, context_params)

    # Initialize message channel
    messages_params = DagsterPipes.ParamsLoader.Protocol.load_messages_params!(params_loader)
    channel = DagsterPipes.MessageWriter.open(message_writer, messages_params)
    :ok = write_message(channel, :opened, message_writer.get_opened_payload())

    {:noreply, %{context | context_data: context_data, message_channel: channel}}
  end

  @impl GenServer
  def terminate(:normal, context) do
    if not context.closed? do
      raise "The context is not closed. Plase make sure its call `DagsterPipes.Context.close(context)` to cleanup resource."
    end

    :ok
  end

  def handle_call({:close, exception, stacktrace}, _from, context) do
    params = %{}

    params =
      if exception do
        Map.put(
          params,
          :exception,
          DagsterPipes.PipesException.to_map(to_pipes_exception(exception, stacktrace))
        )
      else
        params
      end

    result = write_message(context.message_channel, :closed, params)
    {:reply, result, %{context | closed?: true}}
  end

  @impl GenServer
  def handle_call(:context_data, _from, context) do
    {:reply, context.context_data, context}
  end

  @impl GenServer
  def handle_call(
        {:report_asset_materialization, metadata, data_version, asset_key},
        _from,
        context
      ) do
    asset_key = resolve_asset_key(context, asset_key)
    metadata = normalize_metadata!(metadata)

    if MapSet.member?(context.materialized_assets, asset_key) do
      {:reply, {:error, :already_reported}, context}
    else
      result =
        write_message(context.message_channel, :report_asset_materialization, %{
          metadata: metadata,
          data_version: data_version,
          asset_key: asset_key
        })

      {:reply, result,
       %{context | materialized_assets: MapSet.put(context.materialized_assets, asset_key)}}
    end
  end

  @impl GenServer
  def handle_call(
        {:report_asset_check, check_name, passed, severity, metadata, asset_key},
        _from,
        context
      ) do
    asset_key = resolve_asset_key(context, asset_key)
    metadata = normalize_metadata!(metadata)

    result =
      write_message(context.message_channel, :report_asset_check, %{
        check_name: check_name,
        passed: passed,
        severity: severity,
        metadata: metadata,
        asset_key: asset_key
      })

    {:reply, result, context}
  end

  @impl GenServer
  def handle_call({:report_custom_message, payload}, _from, context) do
    result = write_message(context.message_channel, :report_custom_message, %{payload: payload})
    {:reply, result, context}
  end

  ## Helpers

  defp write_message(channel, method, params) do
    DagsterPipes.MessageChannel.write_message(channel, build(method, params))
  end

  @pipes_protocol_version "0.1"

  defp build(method, params) when is_atom(method) and is_map(params) do
    %DagsterPipes.PipesMessage{
      dagster_pipes_version: @pipes_protocol_version,
      method: method,
      params: params
    }
  end

  defp resolve_asset_key(
         %__MODULE__{context_data: %DagsterPipes.PipesContextData{asset_keys: [asset_key]}},
         nil
       ) do
    asset_key
  end

  defp resolve_asset_key(
         %__MODULE__{context_data: %DagsterPipes.PipesContextData{asset_keys: asset_keys}},
         asset_key
       )
       when is_binary(asset_key) do
    if asset_key not in asset_keys do
      raise DagsterPipes.Error, "Invalid asset key: #{asset_key}"
    end

    asset_key
  end

  defp normalize_metadata!(nil), do: nil

  defp normalize_metadata!(metadata) do
    Enum.into(metadata, %{}, fn {key, value} ->
      value =
        value
        |> DagsterPipes.MetadataValue.Protocol.to_metadata_value()
        |> DagsterPipes.PipesMetadataValue.to_map()

      {key, value}
    end)
  end

  defp to_pipes_exception(exception, stacktrace) do
    %DagsterPipes.PipesException{
      message: Exception.message(exception),
      name: exception.__struct__,
      stack:
        stacktrace
        |> Exception.format_stacktrace()
        |> String.split("\n", trim: true)
    }
  end
end
