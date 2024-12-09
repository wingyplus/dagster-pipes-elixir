defmodule DagsterPipes.PartitionTimeWindow do
  @moduledoc "A span of time delimited by a start and end timestamp. This is defined for time-based partitioning schemes."

  @derive Jason.Encoder
  @derive Nestru.Decoder
  defstruct [:start, :end]
end
