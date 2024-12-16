defmodule DagsterPipes.FileMessageWriterChannel do
  @moduledoc """
  A channel for writing messages to a file.
  """

  defstruct [:path]

  def open(path) do
    %__MODULE__{path: path}
  end
end

defimpl DagsterPipes.MessageChannel, for: DagsterPipes.FileMessageWriterChannel do
  def write_message(channel, message) do
    f = File.open!(channel.path, [:append])
    :ok = IO.binwrite(f, [DagsterPipes.PipesMessage.to_json(message), ?\n])
    File.close(f)
  end
end
