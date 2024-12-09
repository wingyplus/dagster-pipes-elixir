defmodule DagsterPipes.MessageWriter do
  @doc """
  Initializes a channel for writing back to Dagster.
  """
  def open(message_writer, params) do
    message_writer.open(params)
  end

  def get_opened_payload(message_writer) do
    message_writer.get_opened_payload()
  end
end
