defmodule Server.Registry do
  use GenServer

  def start_link(_opts \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:register, client_id, role}, state) do
    new_state = Map.put(state, client_id, role)
    # IO.inspect(length(Map.keys(new_state)))
    {:noreply, new_state}
  end
end
