defmodule DagsterPipes.DefaultContextLoader do
  @file_path_key "path"

  def load_context(%{@file_path_key => path}) when is_binary(path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end
end

defmodule DagsterPipes.ContextLoader do
  @doc "Loads a context that injected by orchestrator process."
  def load_context(context_loader, params) do
    context_loader.load_context(params)
    |> DagsterPipes.PipesContextData.from_map()
  end
end
