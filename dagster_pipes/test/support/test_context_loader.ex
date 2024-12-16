defmodule DagsterPipes.TestContextLoader do
  def load_context(_params) do
    %{
      "asset_keys" => ["elixir_pipes"],
      "provenance_by_asset_key" => []
    }
  end
end
