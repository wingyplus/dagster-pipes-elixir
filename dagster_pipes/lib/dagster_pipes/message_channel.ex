defprotocol DagsterPipes.MessageChannel do
  def write_message(channel, message)
end
