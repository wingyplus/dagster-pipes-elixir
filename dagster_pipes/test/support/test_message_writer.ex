defmodule DagsterPipes.TestMessageWriter do
  def open(messages_params) do
    %DagsterPipes.TestMessageChannel{pid: messages_params.pid}
  end

  def get_opened_payload() do
    %{}
  end
end
