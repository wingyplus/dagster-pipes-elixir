defmodule DagsterPipes.TestParamsLoader do
  defstruct [:pid]

  def init(args) do
    struct(__MODULE__, args)
  end
end

defimpl DagsterPipes.ParamsLoader.Protocol, for: DagsterPipes.TestParamsLoader do
  def dagster_pipes_process?(_params_loader) do
    true
  end

  def load_context_params!(_params_loader) do
    %{}
  end

  def load_messages_params!(params_loader) do
    %{pid: params_loader.pid}
  end
end
