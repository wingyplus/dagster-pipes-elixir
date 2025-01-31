# This file was autogenerated using quicktype https://github.com/quicktype/quicktype
#
# Add Jason to your mix.exs
#
# Decode a JSON string: DagsterPipes.AssetCheckSeverity.from_json(data)
# Encode into a JSON string: DagsterPipes.AssetCheckSeverity.to_json(struct)
#
# Decode a JSON string: DagsterPipes.PipesContextData.from_json(data)
# Encode into a JSON string: DagsterPipes.PipesContextData.to_json(struct)
#
# Decode a JSON string: DagsterPipes.PipesException.from_json(data)
# Encode into a JSON string: DagsterPipes.PipesException.to_json(struct)
#
# Decode a JSON string: DagsterPipes.PipesLogLevel.from_json(data)
# Encode into a JSON string: DagsterPipes.PipesLogLevel.to_json(struct)
#
# Decode a JSON string: DagsterPipes.PipesMessage.from_json(data)
# Encode into a JSON string: DagsterPipes.PipesMessage.to_json(struct)
#
# Decode a JSON string: DagsterPipes.PipesMetadataValue.from_json(data)
# Encode into a JSON string: DagsterPipes.PipesMetadataValue.to_json(struct)

defmodule DagsterPipes.AssetCheckSeverity do
  @valid_enum_members [
    :ERROR,
    :WARN
  ]

  def valid_atom?(value), do: value in @valid_enum_members

  def valid_atom_string?(value) do
    try do
      atom = String.to_existing_atom(value)
      atom in @valid_enum_members
    rescue
      ArgumentError -> false
    end
  end

  def encode(value) do
    if valid_atom?(value) do
      Atom.to_string(value)
    else
      {:error, "Unexpected value when encoding atom: #{inspect(value)}"}
    end
  end

  def decode(value) do
    if valid_atom_string?(value) do
      String.to_existing_atom(value)
    else
      {:error, "Unexpected value when decoding atom: #{inspect(value)}"}
    end
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> decode()
  end

  def to_json(data) do
    data
    |> encode()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PartitionKeyRange do
  defstruct [:partition_key_range_end, :start]

  @type t :: %__MODULE__{
          partition_key_range_end: String.t() | nil,
          start: String.t() | nil
        }

  def from_map(m) do
    %DagsterPipes.PartitionKeyRange{
      partition_key_range_end: m["end"],
      start: m["start"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "end" => struct.partition_key_range_end,
      "start" => struct.start
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PartitionTimeWindow do
  defstruct [:partition_time_window_end, :start]

  @type t :: %__MODULE__{
          partition_time_window_end: String.t() | nil,
          start: String.t() | nil
        }

  def from_map(m) do
    %DagsterPipes.PartitionTimeWindow{
      partition_time_window_end: m["end"],
      start: m["start"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "end" => struct.partition_time_window_end,
      "start" => struct.start
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.ProvenanceByAssetKey do
  defstruct [:code_version, :input_data_versions, :is_user_provided]

  @type t :: %__MODULE__{
          code_version: String.t() | nil,
          input_data_versions: %{String.t() => String.t()} | nil,
          is_user_provided: boolean() | nil
        }

  def from_map(m) do
    %DagsterPipes.ProvenanceByAssetKey{
      code_version: m["code_version"],
      input_data_versions: m["input_data_versions"],
      is_user_provided: m["is_user_provided"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "code_version" => struct.code_version,
      "input_data_versions" => struct.input_data_versions,
      "is_user_provided" => struct.is_user_provided
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesContextData do
  @moduledoc """
  The serializable data passed from the orchestration process to the external process. This
  gets wrapped in a PipesContext.
  """

  @enforce_keys [:extras, :retry_number, :run_id]
  defstruct [
    :asset_keys,
    :code_version_by_asset_key,
    :extras,
    :job_name,
    :partition_key,
    :partition_key_range,
    :partition_time_window,
    :provenance_by_asset_key,
    :retry_number,
    :run_id
  ]

  @type t :: %__MODULE__{
          asset_keys: [String.t()] | nil,
          code_version_by_asset_key: %{String.t() => nil | String.t()} | nil,
          extras: %{String.t() => any()} | nil,
          job_name: String.t() | nil,
          partition_key: String.t() | nil,
          partition_key_range: DagsterPipes.PartitionKeyRange.t() | nil,
          partition_time_window: DagsterPipes.PartitionTimeWindow.t() | nil,
          provenance_by_asset_key:
            %{String.t() => DagsterPipes.ProvenanceByAssetKey.t() | nil} | nil | nil,
          retry_number: integer(),
          run_id: String.t()
        }

  def decode_code_version_by_asset_key_value(value) when is_nil(value), do: value
  def decode_code_version_by_asset_key_value(value) when is_binary(value), do: value

  def decode_code_version_by_asset_key_value(_),
    do:
      {:error,
       "Unexpected type when decoding DagsterPipes.PipesContextData.code_version_by_asset_key"}

  def encode_code_version_by_asset_key_value(value) when is_nil(value), do: value
  def encode_code_version_by_asset_key_value(value) when is_binary(value), do: value

  def encode_code_version_by_asset_key_value(_),
    do:
      {:error,
       "Unexpected type when encoding DagsterPipes.PipesContextData.code_version_by_asset_key"}

  def decode_provenance_by_asset_key_value(%{} = value),
    do: DagsterPipes.ProvenanceByAssetKey.from_map(value)

  def decode_provenance_by_asset_key_value(value) when is_nil(value), do: value

  def decode_provenance_by_asset_key_value(_),
    do:
      {:error,
       "Unexpected type when decoding DagsterPipes.PipesContextData.provenance_by_asset_key"}

  def encode_provenance_by_asset_key_value(%DagsterPipes.ProvenanceByAssetKey{} = value),
    do: DagsterPipes.ProvenanceByAssetKey.to_map(value)

  def encode_provenance_by_asset_key_value(value) when is_nil(value), do: value

  def encode_provenance_by_asset_key_value(_),
    do:
      {:error,
       "Unexpected type when encoding DagsterPipes.PipesContextData.provenance_by_asset_key"}

  def from_map(m) do
    %DagsterPipes.PipesContextData{
      asset_keys: m["asset_keys"],
      code_version_by_asset_key: m["code_version_by_asset_key"],
      extras: m["extras"],
      job_name: m["job_name"],
      partition_key: m["partition_key"],
      partition_key_range:
        m["partition_key_range"] &&
          DagsterPipes.PartitionKeyRange.from_map(m["partition_key_range"]),
      partition_time_window:
        m["partition_time_window"] &&
          DagsterPipes.PartitionTimeWindow.from_map(m["partition_time_window"]),
      provenance_by_asset_key:
        m["provenance_by_asset_key"]
        |> Map.new(fn {key, value} -> {key, decode_provenance_by_asset_key_value(value)} end),
      retry_number: m["retry_number"],
      run_id: m["run_id"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "asset_keys" => struct.asset_keys,
      "code_version_by_asset_key" => struct.code_version_by_asset_key,
      "extras" => struct.extras,
      "job_name" => struct.job_name,
      "partition_key" => struct.partition_key,
      "partition_key_range" =>
        struct.partition_key_range &&
          DagsterPipes.PartitionKeyRange.to_map(struct.partition_key_range),
      "partition_time_window" =>
        struct.partition_time_window &&
          DagsterPipes.PartitionTimeWindow.to_map(struct.partition_time_window),
      "provenance_by_asset_key" =>
        struct.provenance_by_asset_key
        |> Map.new(fn {key, value} -> {key, encode_provenance_by_asset_key_value(value)} end),
      "retry_number" => struct.retry_number,
      "run_id" => struct.run_id
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.ContextClass do
  @moduledoc """
  exception that being handled when this exception was raised
  - `:cause` - exception that explicitly led to this exception
  - `:context` - exception that being handled when this exception was raised
  - `:name` - class name of Exception object
  """

  defstruct [:cause, :context, :message, :name, :stack]

  @type t :: %__MODULE__{
          cause: DagsterPipes.PipesExceptionClass.t() | nil | nil,
          context: DagsterPipes.ContextClass.t() | nil,
          message: String.t() | nil,
          name: String.t() | nil,
          stack: [String.t()] | nil
        }

  def from_map(m) do
    %DagsterPipes.ContextClass{
      cause: m["cause"] && DagsterPipes.PipesExceptionClass.from_map(m["cause"]),
      context: m["context"] && DagsterPipes.ContextClass.from_map(m["context"]),
      message: m["message"],
      name: m["name"],
      stack: m["stack"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "cause" => struct.cause && DagsterPipes.PipesExceptionClass.to_map(struct.cause),
      "context" => struct.context && DagsterPipes.ContextClass.to_map(struct.context),
      "message" => struct.message,
      "name" => struct.name,
      "stack" => struct.stack
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesExceptionClass do
  @moduledoc """
  - `:cause` - exception that explicitly led to this exception
  - `:context` - exception that being handled when this exception was raised
  - `:name` - class name of Exception object
  """

  defstruct [:cause, :context, :message, :name, :stack]

  @type t :: %__MODULE__{
          cause: DagsterPipes.PipesExceptionClass.t() | nil | nil,
          context: DagsterPipes.ContextClass.t() | nil,
          message: String.t() | nil,
          name: String.t() | nil,
          stack: [String.t()] | nil
        }

  def from_map(m) do
    %DagsterPipes.PipesExceptionClass{
      cause: m["cause"] && DagsterPipes.PipesExceptionClass.from_map(m["cause"]),
      context: m["context"] && DagsterPipes.ContextClass.from_map(m["context"]),
      message: m["message"],
      name: m["name"],
      stack: m["stack"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "cause" => struct.cause && DagsterPipes.PipesExceptionClass.to_map(struct.cause),
      "context" => struct.context && DagsterPipes.ContextClass.to_map(struct.context),
      "message" => struct.message,
      "name" => struct.name,
      "stack" => struct.stack
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesException do
  @moduledoc """
  - `:cause` - exception that explicitly led to this exception
  - `:context` - exception that being handled when this exception was raised
  - `:name` - class name of Exception object
  """

  defstruct [:cause, :context, :message, :name, :stack]

  @type t :: %__MODULE__{
          cause: DagsterPipes.PipesExceptionClass.t() | nil | nil,
          context: DagsterPipes.ContextClass.t() | nil,
          message: String.t() | nil,
          name: String.t() | nil,
          stack: [String.t()] | nil
        }

  def from_map(m) do
    %DagsterPipes.PipesException{
      cause: m["cause"] && DagsterPipes.PipesExceptionClass.from_map(m["cause"]),
      context: m["context"] && DagsterPipes.ContextClass.from_map(m["context"]),
      message: m["message"],
      name: m["name"],
      stack: m["stack"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "cause" => struct.cause && DagsterPipes.PipesExceptionClass.to_map(struct.cause),
      "context" => struct.context && DagsterPipes.ContextClass.to_map(struct.context),
      "message" => struct.message,
      "name" => struct.name,
      "stack" => struct.stack
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesLogLevel do
  @valid_enum_members [
    :CRITICAL,
    :DEBUG,
    :ERROR,
    :INFO,
    :WARNING
  ]

  def valid_atom?(value), do: value in @valid_enum_members

  def valid_atom_string?(value) do
    try do
      atom = String.to_existing_atom(value)
      atom in @valid_enum_members
    rescue
      ArgumentError -> false
    end
  end

  def encode(value) do
    if valid_atom?(value) do
      Atom.to_string(value)
    else
      {:error, "Unexpected value when encoding atom: #{inspect(value)}"}
    end
  end

  def decode(value) do
    if valid_atom_string?(value) do
      String.to_existing_atom(value)
    else
      {:error, "Unexpected value when decoding atom: #{inspect(value)}"}
    end
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> decode()
  end

  def to_json(data) do
    data
    |> encode()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.Method do
  @moduledoc """
  Event type
  """
  @valid_enum_members [
    :closed,
    :log,
    :opened,
    :report_asset_check,
    :report_asset_materialization,
    :report_custom_message
  ]

  def valid_atom?(value), do: value in @valid_enum_members

  def valid_atom_string?(value) do
    try do
      atom = String.to_existing_atom(value)
      atom in @valid_enum_members
    rescue
      ArgumentError -> false
    end
  end

  def encode(value) do
    if valid_atom?(value) do
      Atom.to_string(value)
    else
      {:error, "Unexpected value when encoding atom: #{inspect(value)}"}
    end
  end

  def decode(value) do
    if valid_atom_string?(value) do
      String.to_existing_atom(value)
    else
      {:error, "Unexpected value when decoding atom: #{inspect(value)}"}
    end
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> decode()
  end

  def to_json(data) do
    data
    |> encode()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesMessage do
  @moduledoc """
  - `:dagster_pipes_version` - The version of the Dagster Pipes protocol
  - `:method` - Event type
  - `:params` - Event parameters
  """

  @enforce_keys [:dagster_pipes_version, :method, :params]
  defstruct [:dagster_pipes_version, :method, :params]

  @type t :: %__MODULE__{
          dagster_pipes_version: String.t(),
          method: DagsterPipes.Method.t(),
          params: %{String.t() => any()} | nil
        }

  def from_map(m) do
    %DagsterPipes.PipesMessage{
      dagster_pipes_version: m["__dagster_pipes_version"],
      method: DagsterPipes.Method.decode(m["method"]),
      params: m["params"]
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "__dagster_pipes_version" => struct.dagster_pipes_version,
      "method" => DagsterPipes.Method.encode(struct.method),
      "params" => struct.params
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.Type do
  @valid_enum_members [
    :asset,
    :bool,
    :dagster_run,
    :float,
    :__infer__,
    :int,
    :json,
    :job,
    :md,
    :notebook,
    :null,
    :path,
    :text,
    :timestamp,
    :url
  ]

  def valid_atom?(value), do: value in @valid_enum_members

  def valid_atom_string?(value) do
    try do
      atom = String.to_existing_atom(value)
      atom in @valid_enum_members
    rescue
      ArgumentError -> false
    end
  end

  def encode(value) do
    if valid_atom?(value) do
      Atom.to_string(value)
    else
      {:error, "Unexpected value when encoding atom: #{inspect(value)}"}
    end
  end

  def decode(value) do
    if valid_atom_string?(value) do
      String.to_existing_atom(value)
    else
      {:error, "Unexpected value when decoding atom: #{inspect(value)}"}
    end
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> decode()
  end

  def to_json(data) do
    data
    |> encode()
    |> Jason.encode!()
  end
end

defmodule DagsterPipes.PipesMetadataValue do
  defstruct [:raw_value, :type]

  @type t :: %__MODULE__{
          raw_value:
            [any()]
            | boolean()
            | float()
            | integer()
            | %{String.t() => any()}
            | nil
            | String.t()
            | nil,
          type: DagsterPipes.Type.t() | nil
        }

  def decode_raw_value(value) when is_boolean(value), do: value
  def decode_raw_value(value) when is_float(value), do: value
  def decode_raw_value(value) when is_integer(value), do: value
  def decode_raw_value(value) when is_nil(value), do: value
  def decode_raw_value(value) when is_binary(value), do: value
  def decode_raw_value(value) when is_list(value), do: value
  def decode_raw_value(value) when is_map(value), do: value

  def decode_raw_value(_),
    do: {:error, "Unexpected type when decoding DagsterPipes.PipesMetadataValue.raw_value"}

  def encode_raw_value(value) when is_boolean(value), do: value
  def encode_raw_value(value) when is_float(value), do: value
  def encode_raw_value(value) when is_integer(value), do: value
  def encode_raw_value(value) when is_nil(value), do: value
  def encode_raw_value(value) when is_binary(value), do: value
  def encode_raw_value(value) when is_list(value), do: value
  def encode_raw_value(value) when is_map(value), do: value

  def encode_raw_value(_),
    do: {:error, "Unexpected type when encoding DagsterPipes.PipesMetadataValue.raw_value"}

  def from_map(m) do
    %DagsterPipes.PipesMetadataValue{
      raw_value: decode_raw_value(m["raw_value"]),
      type: m["type"] && DagsterPipes.Type.decode(m["type"])
    }
  end

  def from_json(json) do
    json
    |> Jason.decode!()
    |> from_map()
  end

  def to_map(struct) do
    %{
      "raw_value" => encode_raw_value(struct.raw_value),
      "type" => struct.type && DagsterPipes.Type.encode(struct.type)
    }
  end

  def to_json(struct) do
    struct
    |> to_map()
    |> Jason.encode!()
  end
end
