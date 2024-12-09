defmodule DagsterPipes.ParamsLoader do
  @moduledoc """
  Object that loads params passed from the orchestration process by the context injector and
  message reader. These params are used to respectively bootstrap the
  `PipesContextLoader` and `PipesMessageWriter`.
  """

  defstruct [:mapping]

  @dagster_pipes_context_env_var "DAGSTER_PIPES_CONTEXT"
  @dagster_pipes_messages_env_var "DAGSTER_PIPES_MESSAGES"

  @doc """
  Constructs params loader at the init time.
  """
  def init(mapping \\ %{}) do
    %__MODULE__{mapping: mapping}
  end

  @doc """
  Contructs params loader that extracts params from environment variables.
  """
  def init_from_env() do
    __MODULE__.init(System.get_env())
  end

  @doc """
  Whether or not this process has been provided with provided with information to create
  a PipesContext or should instead return a mock.
  """
  def dagster_pipes_process?(params_loader) do
    Map.has_key?(params_loader.mapping, @dagster_pipes_context_env_var)
  end

  def load_context_params!(params_loader) do
    params_loader.mapping[@dagster_pipes_context_env_var]
    |> DagsterPipes.Params.decode!()
  end

  def load_messages_params!(params_loader) do
    params_loader.mapping[@dagster_pipes_messages_env_var]
    |> DagsterPipes.Params.decode!()
  end
end
