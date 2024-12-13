defmodule DagsterPipes.TestContextLoader do
  def load_context(_params) do
    %{
      "asset_keys" => ["elixir_pipes"]
    }
  end
end
