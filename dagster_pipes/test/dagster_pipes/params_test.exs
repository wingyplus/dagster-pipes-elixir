defmodule DagsterPipes.ParamsTest do
  use ExUnit.Case, async: true

  @data %{
    "path" => "/var/folders/x7/tl6gyzn92vzcr35t94xgt6y00000gp/T/tmplh3cn4ev/context"
  }

  test "decode/1" do
    encoded_data =
      "eJwVwdEJgCAQANBV4ha4SDNsjhYQNf0wFTtEjXaP3nsgK/KwT4BVFTxTMLbc2DakIFwfUS516MJWkrw5En3+uYwH0pWDZzpyW1GnSLYRvB9CZRtp"

    assert DagsterPipes.Params.decode!(encoded_data) == @data
  end

  test "encode/1" do
    encoded_data = DagsterPipes.Params.encode(@data)
    assert is_binary(encoded_data)
    assert DagsterPipes.Params.decode!(encoded_data) == @data
  end
end
