defmodule Log.LogAck do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :message, 1, type: :string
end

defmodule Log.LogMessage do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :agent_id, 1, type: :string, json_name: "agentId"
  field :message, 2, type: :string
  field :timestamp, 3, type: :int64
  field :source, 4, type: :string
end

defmodule Log.LogService.Service do
  @moduledoc false

  use GRPC.Service, name: "log.LogService", protoc_gen_elixir_version: "0.12.0"

  rpc :SendLog, Log.LogMessage, Log.LogAck
end

defmodule Log.LogService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Log.LogService.Service
end