defmodule BackendWeb.ClientsSocket do
  use Phoenix.Socket

  ## Channels
  channel "clients:*", BackendWeb.ClientsChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
