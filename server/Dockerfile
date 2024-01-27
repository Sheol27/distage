FROM elixir:1.16.0

WORKDIR /app
COPY mix.exs .
RUN mix deps.get && \
    mix local.hex --force && \
    mix deps.compile

COPY lib lib
COPY .formatter.exs .

RUN mix compile

EXPOSE 50051

CMD [ "mix", "run", "--no-halt" ]