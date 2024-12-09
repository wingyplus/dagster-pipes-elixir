defmodule DagsterPipes do
  @moduledoc """
  DagsterPipes allows you to integrate Elixir code with Dagster through [Dagster Pipes](https://docs.dagster.io/concepts/dagster-pipes).
  """

  @doc """
  Initialize the Dagster Pipes context.
  """
  def open(opts \\ []) do
    params_loader = opts[:params_loader] || DagsterPipes.ParamsLoader.init_from_env()

    if DagsterPipes.ParamsLoader.dagster_pipes_process?(params_loader) do
      context_loader = opts[:context_loader] || DagsterPipes.DefaultContextLoader
      message_writer = opts[:message_writer] || DagsterPipes.DefaultMessageWriter

      DagsterPipes.Context.start_link(
        params_loader: params_loader,
        context_loader: context_loader,
        message_writer: message_writer
      )
    else
      # TODO: set mock?
      raise """
      This process was not launched by a Dagster orchestration process. All calls to the
      `dagster-pipes` context or attempts to initialize `dagster-pipes` abstractions
      are no-ops.
      """
    end
  end

  @doc """
  Similar to `open/1` but send a context to a `fun` and close the context after the `fun` is done.
  """
  def open(fun, opts) when is_function(fun, 1) do
    with {:ok, context} = open(opts) do
      result = fun.(context)
      close(context)
      result
    end
  end

  @doc "See `DagsterPipes.Context.report_asset_materialization/4`."
  defdelegate report_asset_materialization(
                context,
                metadata \\ nil,
                data_version \\ nil,
                asset_key \\ nil
              ),
              to: DagsterPipes.Context

  @doc "See `DagsterPipes.Context.close/1`."
  defdelegate close(context), to: DagsterPipes.Context
end
