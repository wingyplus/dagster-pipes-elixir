defmodule DagsterPipes.MixProject do
  use Mix.Project

  def project do
    [
      app: :dagster_pipes,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package() do
    %{
      name: "dagster_pipes",
      description: "The Elixir protocol implementation for Dagster Pipes.",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/wingyplus/dagster-pipes-elixir"}
    }
  end
end
