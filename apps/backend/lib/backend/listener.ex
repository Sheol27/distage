defmodule Backend.Listener do
  use GRPC.Server, service: Timestamp.TimestampService.Service

  def send_timestamp(request, _stream) do
    role = determine_role(request.creation_timestamp)

    client_id =
      case request.uuid do
        nil -> UUID.uuid4()
        "" -> UUID.uuid4()
        uuid -> uuid
      end

    GenServer.cast(Backend.Registry, {:register, client_id, role})

    %Timestamp.RoleResponse{role: role, uuid: client_id}
  end

  defp determine_role(_timestamp) do
    "generic_role"
  end
end
