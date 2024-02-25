defmodule BackendWeb.ClientsChannel do
  use BackendWeb, :channel

  @impl true
  def join("clients:info", payload, socket) do
    if authorized?(payload) do
      send(self(), :send_clients)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("clients:" <> id, payload, socket) do
    if authorized?(payload) do
      IO.puts("Joined #{id}")
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(:send_clients, socket) do
    clients = Backend.Registry.get_state()

    push(socket, "clients", clients)
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
