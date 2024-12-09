defmodule DagsterPipes.PartitionKeyRange do
  @moduledoc "A range of partition key."

  @derive Jason.Encoder
  @derive Nestru.Decoder
  defstruct [:start, :end]
end
