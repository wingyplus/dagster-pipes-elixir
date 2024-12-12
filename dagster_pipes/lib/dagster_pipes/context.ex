defmodule DagsterPipes.Context do
  @moduledoc """
  The context of the Dagster Pipes process.
  """

  use GenServer

  defstruct [
    :context_data,
    :message_channel
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
  Report to the Dagster that asset is materialized.
  """
  # TODO: prevent calling this function twice. (Ref: https://github.com/dagster-io/dagster/blob/master/python_modules/dagster-pipes/dagster_pipes/__init__.py#L1626-L1631)
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
    context_params = DagsterPipes.ParamsLoader.load_context_params!(params_loader)
    context_data = DagsterPipes.ContextLoader.load_context(context_loader, context_params)

    # Initialize message channel
    messages_params = DagsterPipes.ParamsLoader.load_messages_params!(params_loader)
    channel = DagsterPipes.MessageWriter.open(message_writer, messages_params)
    :ok = write_message(channel, "opened", message_writer.get_opened_payload())

    {:noreply, %{context | context_data: context_data, message_channel: channel}}
  end

  @impl GenServer
  def terminate(:normal, context) do
    write_message(context.message_channel, "closed", %{})
  end

  @impl GenServer
  def handle_call(
        {:report_asset_materialization, metadata, data_version, asset_key},
        _from,
        context
      ) do
    asset_key = resolve_asset_key(context, asset_key)

    result =
      write_message(context.message_channel, "report_asset_materialization", %{
        metadata: metadata,
        data_version: data_version,
        asset_key: asset_key
      })

    {:reply, result, context}
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
end
