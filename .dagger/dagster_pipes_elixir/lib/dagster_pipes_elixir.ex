defmodule DagsterPipesElixir do
  @moduledoc """
  CI/CD implementation for DagsterPipes Elixir.
  """

  use Dagger.Mod.Object, name: "DagsterPipesElixir"

  @image "hexpm/elixir:1.17.3-erlang-27.2-debian-bookworm-20241202-slim@sha256:85b1ee53b5d56052089050041841e652d821c431cb41648c87066956984f15b0"

  @doc """
  Test `dagster_pipes` project.
  """
  defn test(source: {Dagger.Directory.t(), default_path: "."}) :: Dagger.Container.t() do
    dag()
    |> Dagger.Client.container()
    |> Dagger.Container.from(@image)
    |> Dagger.Container.with_workdir("/dagster-pipes-elixir")
    |> Dagger.Container.with_exec(~w"mix local.rebar --force")
    |> Dagger.Container.with_exec(~w"mix local.hex --force")
    |> Dagger.Container.with_mounted_directory(".", source)
    |> Dagger.Container.with_workdir("dagster_pipes")
    |> Dagger.Container.with_env_variable("MIX_ENV", "test")
    |> Dagger.Container.with_exec(~w"mix deps.get")
    |> Dagger.Container.with_exec(~w"mix deps.compile")
    |> Dagger.Container.with_exec(~w"mix compile")
    |> Dagger.Container.with_exec(~w"mix test")
  end
end
