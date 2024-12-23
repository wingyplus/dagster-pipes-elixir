defmodule DagsterPipes.MetadataValue do
  @moduledoc """
  Provides set of functions to converting Elixir value into `DagsterPipes.PipesMetadataValue`.
  """

  def notebook(nb) when is_binary(nb) do
    %DagsterPipes.PipesMetadataValue{raw_value: nb, type: :notebook}
  end

  def path(path) when is_binary(path) do
    %DagsterPipes.PipesMetadataValue{raw_value: path, type: :path}
  end

  def markdown(md) when is_binary(md) do
    %DagsterPipes.PipesMetadataValue{raw_value: md, type: :md}
  end

  def asset(asset) when is_binary(asset) do
    %DagsterPipes.PipesMetadataValue{raw_value: asset, type: :asset}
  end

  def dagster_run(run_id) when is_binary(run_id) do
    %DagsterPipes.PipesMetadataValue{raw_value: run_id, type: :dagster_run}
  end
end

defprotocol DagsterPipes.MetadataValue.Protocol do
  @moduledoc """
  A protocol for converting Elixir value into `DagsterPipes.PipesMetadataValue`.
  """

  @doc """
  Convert value into `DagsterPipes.PipesMetadataValue`.
  """
  def to_metadata_value(value)
end

defimpl DagsterPipes.MetadataValue.Protocol, for: [Atom, BitString] do
  def to_metadata_value(nil) do
    %DagsterPipes.PipesMetadataValue{raw_value: nil, type: :null}
  end

  def to_metadata_value(value) when is_boolean(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: value, type: :bool}
  end

  def to_metadata_value(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: to_string(value), type: :text}
  end
end

defimpl DagsterPipes.MetadataValue.Protocol, for: Integer do
  def to_metadata_value(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: value, type: :int}
  end
end

defimpl DagsterPipes.MetadataValue.Protocol, for: Float do
  def to_metadata_value(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: value, type: :float}
  end
end

defimpl DagsterPipes.MetadataValue.Protocol, for: Map do
  def to_metadata_value(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: value, type: :json}
  end
end

defimpl DagsterPipes.MetadataValue.Protocol, for: URI do
  def to_metadata_value(value) do
    %DagsterPipes.PipesMetadataValue{raw_value: URI.to_string(value), type: :url}
  end
end

defimpl DagsterPipes.MetadataValue.Protocol, for: DagsterPipes.PipesMetadataValue do
  def to_metadata_value(value) do
    value
  end
end
