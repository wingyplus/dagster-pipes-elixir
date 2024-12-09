defmodule DagsterPipes.ContextData do
  @moduledoc """
  A message sent from orhestrator process to the external process.
  """

  @derive Jason.Encoder
  @derive {Nestru.Decoder,
           hint: %{
             provenance_by_asset_key: DagsterPipes.DataProvenance,
             partition_key_range: DagsterPipes.PartitionKeyRange,
             partition_time_window: DagsterPipes.PartitionTimeWindow
           }}
  defstruct [
    :asset_keys,
    :code_version_by_asset_key,
    :provenance_by_asset_key,
    :partition_key,
    :partition_key_range,
    :partition_time_window,
    :run_id,
    :job_name,
    :retry_number,
    :extras
  ]
end
