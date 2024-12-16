defmodule DagsterPipes.Context do
  @moduledoc """
  The context of the Dagster Pipes process.
  """

  use GenServer

  defstruct [
    :context_data,
    :message_channel,
    materialized_assets: MapSet.new()
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
  def close(context) do
    GenServer.stop(context)
  end

  @doc """
  A key-value map for all extras provided by the user.
  """
  def extras(context) do
    GenServer.call(context, :extras)
  end

  @doc """
  The partition key for the currently scoped partition.
  """
  def partition_key(context) do
    GenServer.call(context, :partition_key)
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
        severity \\ :error,
        metadata \\ nil,
        asset_key \\ nil
      )
      when is_binary(check_name) and is_boolean(passed) do
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
    :ok = write_message(channel, "opened", message_writer.get_opened_payload())

    {:noreply, %{context | context_data: context_data, message_channel: channel}}
  end

  @impl GenServer
  def terminate(:normal, context) do
    write_message(context.message_channel, "closed", %{})
  end

  @impl GenServer
  def handle_call(:extras, _from, context) do
    {:reply, context.context_data.extras, context}
  end

  @impl GenServer
  def handle_call(:partition_key, _from, context) do
    {:reply, context.context_data.partition_key, context}
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
        write_message(context.message_channel, "report_asset_materialization", %{
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
        {:report_asset_check, _check_name, _passed, _severity, _metadata, _asset_key},
        _from,
        _context
      ) do
    raise "TODO"
  end

  @impl GenServer
  def handle_call({:report_custom_message, _payload}, _from, _context) do
    raise "TODO"
  end

  ## Helpers

  defp write_message(channel, method, params) do
    DagsterPipes.MessageChannel.write_message(channel, DagsterPipes.Message.build(method, params))
  end

  defp resolve_asset_key(
         %__MODULE__{context_data: %DagsterPipes.ContextData{asset_keys: [asset_key]}},
         nil
       ) do
    asset_key
  end

  defp resolve_asset_key(
         %__MODULE__{context_data: %DagsterPipes.ContextData{asset_keys: asset_keys}},
         asset_key
       )
       when is_binary(asset_key) do
    if asset_key not in asset_keys do
      raise DagsterPipes.Error, "Invalid asset key: #{asset_key}"
    end

    asset_key
  end

  defp normalize_metadata!(metadata) do
    Enum.into(metadata, %{}, &normalize_param_metadata!/1)
  end

  defp normalize_param_metadata!({key, value}) when is_binary(key) or is_atom(key) do
    {key, normalize_value_metadata(value)}
  end

  defp normalize_value_metadata(%DagsterPipes.MetadataValue{} = value) do
    value
  end

  defp normalize_value_metadata(value) do
    DagsterPipes.MetadataValue.infer(value)
  end
end
