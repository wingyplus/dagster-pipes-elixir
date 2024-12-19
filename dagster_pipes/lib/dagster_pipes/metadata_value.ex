defmodule DagsterPipes.MetadataValue do
  @moduledoc """
  Provides set of functions to converting Elixir value into `DagsterPipes.PipesMetadataValue`.
  """

  # def boolean(b) when is_boolean(b) do
  #   %DagsterPipes.PipesMetadataValue{raw_value: b, type: :bool}
  # end
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

defimpl DagsterPipes.MetadataValue.Protocol, for: DagsterPipes.PipesMetadataValue do
  def to_metadata_value(value) do
    value
  end
end
