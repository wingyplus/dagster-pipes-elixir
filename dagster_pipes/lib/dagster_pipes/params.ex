defmodule DagsterPipes.Params do
  @moduledoc "Provides functionality to work with Dagster parameters."

  # TODO: Change to Elixir JSON stdlib once it's released. (https://github.com/elixir-lang/elixir/pull/14021).

  def encode(params) do
    params
    |> Jason.encode!()
    |> zlib_compress()
    |> Base.encode64()
  end

  def decode!(params) do
    params
    |> Base.decode64!()
    |> zlib_decompress!()
    |> Jason.decode!()
  end

  ## Zlib helpers

  defp zlib_compress(data) do
    z = :zlib.open()
    :zlib.deflateInit(z, 6)
    compressed = :zlib.deflate(z, data, :finish)
    :zlib.deflateEnd(z)
    :zlib.close(z)
    IO.iodata_to_binary(compressed)
  end

  defp zlib_decompress!(data) do
    z = :zlib.open()
    :zlib.inflateInit(z)
    decompressed = :zlib.inflate(z, data)
    :zlib.inflateEnd(z)
    :zlib.close(z)
    IO.iodata_to_binary(decompressed)
  end
end
