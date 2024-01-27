FROM elixir:1.16.0

WORKDIR /app

RUN apt update && \
    apt install -y protobuf-compiler && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mix escript.install --force hex protobuf

ENV PATH="/root/.mix/escripts:${PATH}"


COPY . .

CMD protoc --elixir_out=plugins=grpc:/app --proto_path=/app/ /app/*.proto