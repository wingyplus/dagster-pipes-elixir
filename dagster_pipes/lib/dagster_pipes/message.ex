defmodule DagsterPipes.Message do
  @moduledoc """
  A message sent from external process to the orchestrator process.
  """

  @derive Jason.Encoder
  defstruct [:__dagster_pipes_version, :method, :params]

  @pipes_protocol_version "0.1"

  @doc """
  Build the Dagster Pipes message.
  """
  def build(method, params) do
    %__MODULE__{
      __dagster_pipes_version: @pipes_protocol_version,
      method: method,
      params: params
    }
  end
end
