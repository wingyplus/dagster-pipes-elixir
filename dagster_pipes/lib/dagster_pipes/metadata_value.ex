defmodule DagsterPipes.MetadataValue do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:type, :raw_value]

  def infer(value) do
    %__MODULE__{type: "__infer__", raw_value: value}
  end
end
