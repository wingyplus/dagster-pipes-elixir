defmodule DagsterPipesElixir do
  @moduledoc """
  CI/CD implementation for DagsterPipes Elixir.
  """

  use Dagger.Mod.Object, name: "DagsterPipesElixir"

  @doc """
  Test `dagster_pipes` project.
  """
  defn test(source: {Dagger.Directory.t(), default_path: "."}) :: Dagger.Container.t() do
    elixir()
    |> with_source(source)
    |> Dagger.Container.with_workdir("dagster_pipes")
    |> Dagger.Container.with_env_variable("MIX_ENV", "test")
    |> Dagger.Container.with_exec(~w"mix deps.get")
    |> Dagger.Container.with_exec(~w"mix deps.compile")
    |> Dagger.Container.with_exec(~w"mix compile")
    |> Dagger.Container.with_exec(~w"mix test")
  end

  @doc """
  Run integration tests provided by Dagster.
  """
  defn integration_test(source: {Dagger.Directory.t(), default_path: "."}) :: Dagger.Container.t() do
    elixir()
    |> with_source(source)
    |> Dagger.Container.with_workdir("integration_tests")
    |> Dagger.Container.with_env_variable("PATH", "/root/.local/bin:$PATH", expand: true)
    |> Dagger.Container.with_exec(~w"apt update")
    |> Dagger.Container.with_exec(~w"apt install -y --no-install-recommends curl git")
    |> Dagger.Container.with_exec(["sh", "-c", "curl -LsSf https://astral.sh/uv/install.sh | sh"])
    |> Dagger.Container.with_exec(~w"uv run pytest")
  end

  @doc """
  Generate Dagster Pipes type definitions from Dagster community repository.
  """
  defn generate() :: Dagger.File.t() do
    generated_file =
      quicktype()
      |> Dagger.Container.with_workdir("jsonschema")
      |> Dagger.Container.with_directory(".", pipes_jsonschema())
      |> Dagger.Container.with_exec([
        "sh",
        "-c",
        "bunx quicktype -s schema -l elixir -o gen.ex --namespace DagsterPipes *.schema.json"
      ])
      |> Dagger.Container.file("gen.ex")

    elixir()
    |> Dagger.Container.with_file("/gen.ex", generated_file)
    |> Dagger.Container.with_exec(~w"mix format /gen.ex")
    |> Dagger.Container.file("/gen.ex")
  end

  @bun_image "oven/bun:1@sha256:5148f6742ac31fac28e6eab391ab1f11f6dfc0c8512c7a3679b374ec470f5982"

  @doc """
  Pre-installed quicktype binary.
  """
  defn quicktype() :: Dagger.Container.t() do
    dag()
    |> Dagger.Client.container()
    |> Dagger.Container.from(@bun_image)
    |> Dagger.Container.with_exec(~w"bun install -g quicktype")
  end

  @elixir_image "hexpm/elixir:1.17.3-erlang-27.2-debian-bookworm-20241202-slim@sha256:85b1ee53b5d56052089050041841e652d821c431cb41648c87066956984f15b0"

  @doc """
  Base Elixir image.
  """
  defn elixir() :: Dagger.Container.t() do
    dag()
    |> Dagger.Client.container()
    |> Dagger.Container.from(@elixir_image)
    |> Dagger.Container.with_exec(~w"mix local.rebar --force")
    |> Dagger.Container.with_exec(~w"mix local.hex --force")
  end

  def with_source(container, source) do
    container
    |> Dagger.Container.with_workdir("/dagster-pipes-elixir")
    |> Dagger.Container.with_mounted_directory(".", source)
  end

  def pipes_jsonschema() do
    dag()
    |> Dagger.Client.git("https://github.com/dagster-io/community-integrations.git")
    |> Dagger.GitRepository.branch("main")
    |> Dagger.GitRef.tree()
    |> Dagger.Directory.directory("libraries/pipes/jsonschema")
  end
end
