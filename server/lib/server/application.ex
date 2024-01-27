defmodule Server.Application do
  use Application

  @impl true
  def start(_type, _args) do
    :ok = Logger.configure(level: :error)

    children = [
      {GRPC.Server.Supervisor, endpoint: Server.Endpoint, port: 50051, start_server: true},
      Server.Registry
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
