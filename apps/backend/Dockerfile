FROM elixir:1.16.0

WORKDIR /app
COPY mix.exs .
RUN mix deps.get && \
  mix local.hex --force && \
  mix archive.install --force hex phx_new && \
  mix deps.compile

COPY lib lib
COPY config config
COPY priv priv
COPY .formatter.exs .

RUN mix compile

EXPOSE 4000

CMD [ "mix", "phx.server"]
