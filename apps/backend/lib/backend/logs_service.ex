defmodule Backend.LogsService do
  use GRPC.Server, service: Log.LogService.Service

  def send_log(request, _stream) do
    uuid = request.agent_id
    BackendWeb.Endpoint.broadcast("clients:#{uuid}", "new_log", Map.from_struct(request))
    %Log.LogAck{message: "Ok"}
  end
end
