defmodule Ghagen do
  @moduledoc """
  A module for scaffolding GitHub workflow using [gha](https://github.com/dagger/dagger/tree/main/modules/gha) module.
  """

  use Dagger.Mod.Object, name: "Ghagen"

  @doc """
  Initialize GHA module with automatic setup module dependencies and example.
  """
  defn init(lang: String.t()) :: Dagger.Directory.t() do
    # TODO: create .github.
    # TODO: bootstraping code.
    # TODO: pre-generate workflow files.
    # TODO: export the directory.
    with :ok <- ensure_lang_valid(lang) do
      dag()
      |> Dagger.Client.container()
      |> init_sdk(lang)
      |> Dagger.Container.directory("/dot-github")
    end
  end

  defp init_sdk(container, lang) do
    container
    |> Dagger.Container.from("alpine")
    # |> with_docker()
    |> with_dagger()
    |> Dagger.Container.with_workdir("/dot-github")
    |> Dagger.Container.with_exec(~w"dagger init --sdk=#{lang} --name=dot-github --source=.",
      experimental_privileged_nesting: true
    )
    |> Dagger.Container.with_exec(~w"dagger install github.com/dagger/dagger/modules/gha",
      experimental_privileged_nesting: true
    )
  end

  defp with_dagger(container) do
    engine_toml = """
    insecure-entitlements = ["security.insecure"]

    [grpc]
    address = ["unix:///var/run/buildkit/buildkitd.sock", "tcp://0.0.0.0:1234"]
    """

    dagger =
      dag()
      |> Dagger.Client.container()
      |> Dagger.Container.from("registry.dagger.io/engine:v0.15.1")

    dagger_cli =
      dagger
      |> Dagger.Container.file("/usr/local/bin/dagger")

    dagger_engine =
      dagger
      |> Dagger.Container.with_new_file("/etc/dagger/engine.toml", engine_toml)
      |> Dagger.Container.with_exposed_port(1234, protocol: Dagger.NetworkProtocol.tcp())
      |> Dagger.Container.as_service(
        use_entrypoint: true,
        experimental_privileged_nesting: true,
        insecure_root_capabilities: true
      )

    container
    |> Dagger.Container.with_env_variable(
      "_EXPERIMENTAL_DAGGER_RUNNER_HOST",
      "tcp://dagger-engine:1234"
    )
    |> Dagger.Container.with_service_binding("dagger-engine", dagger_engine)
    |> Dagger.Container.with_file("/usr/local/bin/dagger", dagger_cli)
  end

  defp ensure_lang_valid("elixir"), do: :ok
  defp ensure_lang_valid(lang), do: {:error, "Initialize with language #{lang} is not support"}
end
