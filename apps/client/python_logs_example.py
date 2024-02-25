import socket
import sys
import time


def send_log(socket_path, message):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        try:
            sock.connect(socket_path)
            sock.sendall(message.encode("utf-8"))
        except socket.error as msg:
            print(f"Socket error: {msg}")


if __name__ == "__main__":
    socket_path = "/tmp/elixir_log_server.sock"

    counter = 1
    while True:
        log_message = f"Test: Log {counter}"
        send_log(socket_path, log_message)
        counter += 1
        time.sleep(1)
