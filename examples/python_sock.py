import socket
import sys


def send_log(socket_path, message):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        try:
            sock.connect(socket_path)
            sock.sendall(message.encode("utf-8"))
        except socket.error as msg:
            print(f"Socket error: {msg}")
            sys.exit(1)


if __name__ == "__main__":
    socket_path = "/tmp/elixir_log_server.sock"
    log_message = "Hello from Python!"

    send_log(socket_path, log_message)
