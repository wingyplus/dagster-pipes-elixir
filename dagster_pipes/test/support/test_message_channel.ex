defmodule DagsterPipes.TestMessageChannel do
  defstruct [:pid]
end

defimpl DagsterPipes.MessageChannel, for: DagsterPipes.TestMessageChannel do
  def write_message(channel, message) do
    send(channel.pid, message)
    :ok
  end
end
