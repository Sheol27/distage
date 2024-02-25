defmodule Client.Worker do
  use GenServer

  @heartbeat_interval 500

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def send_logs(log) do
    GenServer.cast(__MODULE__, {:logs, log})
    :ok
  end

  defp send_timestamp(channel, uuid, host_name) do
    request = %Timestamp.TimestampRequest{
      creation_timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      uuid: uuid,
      host_name: host_name
    }

    {:ok, response} = channel |> Timestamp.TimestampService.Stub.send_timestamp(request)
    %{channel: channel, uuid: response.uuid, host_name: host_name}
  end

  defp send_heartbeat() do
    Process.send_after(self(), :heartbeat, @heartbeat_interval)
  end

  ### Callbacks 

  def init(_opts) do
    {:ok, channel} = GRPC.Stub.connect("backend:50051")

    {:ok, hostname} = :inet.gethostname()

    state = %{channel: channel, uuid: "", host_name: to_string(hostname)}
    send_heartbeat()
    {:ok, state}
  end

  def handle_info(:heartbeat, state) do
    new_state = send_timestamp(state.channel, state.uuid, state.host_name)
    send_heartbeat()

    {:noreply, new_state}
  end

  def handle_cast({:logs, body}, state) do
    new_body = Map.put(body, :agent_id, state.uuid)
    {:ok, _response} = state.channel |> Log.LogService.Stub.send_log(new_body)

    {:noreply, state}
  end
end
