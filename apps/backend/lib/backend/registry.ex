defmodule Backend.Registry do
  use GenServer

  @type role :: String.t()
  @type client_id :: String.t()
  @type timestamp :: DateTime.t()

  @doc """
  Starts the GenServer with an optional initial state.
  """
  def start_link(_opts \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Initializes the server state.
  """
  def init(state) do
    heart_beat()
    {:ok, state}
  end

  @doc """
  Public API to get the current state of the registry.
  """
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def heart_beat(), do: Process.send_after(self(), :heartbeat, 1000)

  ### Callbacks

  @doc """
  Register new clients, notifying the channel.
  """
  def handle_cast({:register, client_id, role}, state) do
    timestamp = DateTime.utc_now()

    client_info = Map.get(state, client_id, %{})
    client_info = Map.put(client_info, :role, role)
    client_info = Map.put(client_info, :timestamp, timestamp)
    client_info = Map.put(client_info, :status, :running)

    new_state = Map.put(state, client_id, client_info)

    unless Map.has_key?(state, client_id) do
      BackendWeb.Endpoint.broadcast("clients:info", "new_client", %{client_id => client_info})
    end

    {:noreply, new_state}
  end

  @doc """
  Return the state.
  """
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc """

  """
  def handle_info(:heartbeat, state) do
    current_time = DateTime.utc_now()

    new_state =
      Enum.reduce(state, %{}, fn {client_id, client_info}, acc ->
        time_diff = DateTime.diff(current_time, client_info.timestamp)

        cond do
          time_diff <= 1 ->
            Map.put(acc, client_id, client_info)

          time_diff > 1 && client_info.status == :running ->
            updated_info = Map.put(client_info, :status, :stopped)

            BackendWeb.Endpoint.broadcast("clients:info", "client_stopped", %{
              client_id => updated_info
            })

            Map.put(acc, client_id, updated_info)

          time_diff > 1 && client_info.status == :stopped ->
            Map.put(acc, client_id, client_info)
        end
      end)

    heart_beat()

    {:noreply, new_state}
  end
end
