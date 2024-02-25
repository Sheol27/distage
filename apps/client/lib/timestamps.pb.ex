defmodule Timestamp.TimestampRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :creation_timestamp, 1, type: :int64, json_name: "creationTimestamp"
  field :uuid, 2, type: :string
  field :host_name, 3, type: :string, json_name: "hostName"
end

defmodule Timestamp.RoleResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :role, 1, type: :string
  field :uuid, 2, type: :string
end

defmodule Timestamp.TimestampService.Service do
  @moduledoc false

  use GRPC.Service, name: "timestamp.TimestampService", protoc_gen_elixir_version: "0.12.0"

  rpc :SendTimestamp, Timestamp.TimestampRequest, Timestamp.RoleResponse
end

defmodule Timestamp.TimestampService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Timestamp.TimestampService.Service
end