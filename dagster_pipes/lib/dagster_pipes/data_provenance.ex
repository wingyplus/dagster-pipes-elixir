defmodule DagsterPipes.DataProvenance do
  @moduledoc "Provenance information of an asset."

  @derive Jason.Encoder
  @derive Nestru.Decoder
  defstruct [:code_version, :input_data_versions, :is_user_provided]
end
