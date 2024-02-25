defmodule Backend.GrpcEndpoint do
  use GRPC.Endpoint

  intercept(GRPC.Server.Interceptors.Logger)
  run([Backend.TimestampService, Backend.LogsService])
end
