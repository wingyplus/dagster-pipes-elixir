defmodule DotGithub do
  @moduledoc """
  The GitHub workflows module. 

  Once you edit this file. It's needs to re-generate by calling
  `dagger call generate export --path=.`. Assume that the current working
  directory is the root of your project.
  """

  use Dagger.Mod.Object, name: "DotGithub"

  # All defined workflows.
  defp workflows() do
    dag()
    |> Dagger.Client.gha()
    |> Dagger.Gha.with_workflow(test_pr_workflow())
  end

  defp test_pr_workflow() do
    dag()
    |> Dagger.Client.gha()
    |> Dagger.Gha.workflow("test", on_pull_request: true)
    |> Dagger.GhaWorkflow.with_job(
      dag()
      |> Dagger.Client.gha()
      |> Dagger.Gha.job(
        "Run Test",
        "dagger call test",
        runner: ["ubuntu-latest"]
      )
    )
  end

  @doc """
  Generate the workflows into YAML files.
  """
  defn generate() :: Dagger.Directory.t() do
    workflows()
    |> Dagger.Gha.generate()
  end
end
