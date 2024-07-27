defmodule Backend.Log do
  @moduledoc false

  defstruct [:id, :agent_id, :timestamp, :content]
end

defimpl Elasticsearch.Document, for: Backend.Log do
  def id(log), do: log.id
  def routing(_), do: false

  def encode(log) do
    %{
      agent_id: log.agent_id,
      timestamp: log.timestamp,
      content: log.content
    }
  end
end
