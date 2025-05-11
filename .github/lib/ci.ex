defmodule Ci do
  @moduledoc false

  use Dagger.Mod.Object, name: "Ci"

  defn generate() :: Dagger.Directory.t() do
    dag()
    |> Dagger.Client.gha()
    |> Dagger.Gha.with_workflow(test())
    |> Dagger.Gha.generate()
  end

  defp test() do
    dag()
    |> Dagger.Client.gha()
    |> Dagger.Gha.workflow("ci", on_pull_request: true)
    |> Dagger.GhaWorkflow.with_job(
      dag()
      |> Dagger.Client.gha()
      |> Dagger.Gha.job("check", "init check")
    )
  end
end
