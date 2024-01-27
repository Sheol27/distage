defmodule Client.Worker do
  use GenServer

  @heartbeat_interval 500

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, channel} = GRPC.Stub.connect("server:50051")
    state = %{channel: channel, uuid: ""}

    send_heartbeat()
    {:ok, state}
  end

  def handle_info(:heartbeat, state) do
    new_state = send_timestamp(state.channel, state.uuid)
    send_heartbeat()

    {:noreply, new_state}
  end

  defp send_timestamp(channel, uuid) do
    request = %Timestamp.TimestampRequest{
      creation_timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      uuid: uuid
    }

    {:ok, response} = channel |> Timestamp.TimestampService.Stub.send_timestamp(request)
    %{channel: channel, uuid: response.uuid}
  end

  defp send_heartbeat() do
    Process.send_after(self(), :heartbeat, @heartbeat_interval)
  end
end
