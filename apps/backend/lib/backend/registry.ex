defmodule Backend.Registry do
  use GenServer

  @doc """
  Starts the GenServer with an optional initial state.
  """
  def start_link(_opts \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Initializes the server state.
  """
  def init(state), do: {:ok, state}

  @doc """
  Public API to get the current state of the registry.
  """
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  ### Callbacks

  @doc """
  Register new clients, notifying the channel.
  """
  def handle_cast({:register, client_id, role}, state) do
    unless Map.has_key?(state, client_id) do
      BackendWeb.Endpoint.broadcast("clients:info", "new_client", %{body: client_id})
    end

    new_state = Map.put(state, client_id, role)

    {:noreply, new_state}
  end

  @doc """
  Return the state 
  """
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
