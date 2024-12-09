defmodule DagsterPipes.MetadataValue do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:type, :raw_value]
end
