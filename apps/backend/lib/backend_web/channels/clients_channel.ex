defmodule BackendWeb.ClientsChannel do
  alias Backend.Elasticsearch
  use BackendWeb, :channel

  @impl true
  def join("clients:info", payload, socket) do
    callback = fn ->
      send(self(), :send_clients)
      {:ok, socket}
    end

    callback |> handle_join(payload)
  end

  @impl true
  def join("clients:" <> id, payload, socket) do
    callback = fn ->
      IO.puts("Joined #{id}")
      send(self(), {:send_history, id})

      {:ok, socket}
    end

    callback |> handle_join(payload)
  end

  # Helper function to check the authorization
  defp handle_join(callback, payload) do
    if authorized?(payload) do
      callback.()
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

  @impl true
  def handle_info({:send_history, id}, socket) do
    {:ok, history} = Elasticsearch.get_documents(id)

    case push(socket, "logs_history", %{history: history}) do
      :ok -> :ok
      {:error, reason} -> IO.inspect(reason)
    end

    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
