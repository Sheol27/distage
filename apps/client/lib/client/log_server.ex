defmodule Client.LogServer do
  use GenServer

  def start_link(init_state \\ %{}) do
    GenServer.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  def init(_init_state) do
    sockname = Path.join(System.tmp_dir(), "elixir_log_server.sock")

    socket = configure_socket(sockname)

    Task.start_link(fn -> loop_accept(socket) end)

    {:ok, {:socket, socket}}
  end

  defp check_existing_socket(sockname) do
    case File.rm(sockname) do
      :ok -> :ok
      {:error, :enoent} -> :ok
      {:error, _} = err -> IO.puts("Error removing socket: #{inspect(err)}")
    end
  end

  defp configure_socket(sockname) do
    check_existing_socket(sockname)

    {:ok, socket} = :socket.open(:local, :stream, %{})
    :ok = :socket.bind(socket, %{family: :local, path: sockname})
    :ok = :socket.listen(socket, 5)

    socket
  end

  defp loop_accept(socket) do
    case :socket.accept(socket) do
      {:ok, client} ->
        Task.start_link(fn -> handle_client(client) end)
        loop_accept(socket)

      {:error, _} = err ->
        IO.puts("Error accepting connection: #{inspect(err)}")
    end
  end

  defp handle_client(client) do
    receive_data(client)
    :ok = :socket.close(client)
  end

  defp receive_data(client) do
    case :socket.recv(client, 0) do
      {:ok, data} when data != "" ->
        msg = String.trim(data)

        log = process_log_message(msg)
        Client.Worker.send_logs(log)

        receive_data(client)

      _ ->
        :ok
    end
  end

  defp process_log_message(msg) do
    [source, message] = String.split(msg, ":", parts: 2)

    %Log.LogMessage{
      message: message,
      timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      source: source
    }
  end
end
