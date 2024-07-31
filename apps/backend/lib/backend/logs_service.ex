defmodule Backend.LogsService do
  use GRPC.Server, service: Log.LogService.Service

  def send_log(request, _stream) do
    uuid = request.agent_id
    BackendWeb.Endpoint.broadcast("clients:#{uuid}", "new_log", Map.from_struct(request))

    result =
      Elasticsearch.post_document(
        Backend.ElasticsearchCluster,
        %Backend.Log{
          agent_id: request.agent_id,
          timestamp: request.timestamp,
          content: request.message
        },
        "logs"
      )

    case result do
      {:ok, _map} ->
        :ok

      _ ->
        IO.puts("Post document failed")
        IO.inspect(result)
        {:error, "Post document failed"}
    end

    %Log.LogAck{message: "Ok"}
  end
end
