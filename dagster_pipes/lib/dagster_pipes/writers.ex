defmodule DagsterPipes.DefaultMessageWriter do
  @moduledoc """
  Default behaviour of writing messages back to Dagster.
  """

  @file_path_key "path"
  # @stdio_key "stdio"
  # @buffered_stdio_key "buffered_stdio"
  # @stderr "stderr"
  # @stdout "stdout"
  # @include_stdio_in_messages_key "include_stdio_in_messages"

  @doc """
  Initializes a channel to write back to Dagster by detecting from `params`.
  """
  def open(%{@file_path_key => path}) when is_binary(path) do
    DagsterPipes.FileMessageWriterChannel.open(path)
  end

  def get_opened_payload() do
    %{extras: get_opened_extras()}
  end

  defp get_opened_extras() do
    %{}
  end
end
