defmodule Backend.Elasticsearch do
  alias Backend.ElasticsearchCluster

  @doc """
  Get all the documents stored
  """
  @spec get_documents(String.t()) :: {:ok, map()} | {:error, any()}
  def get_documents(agent_id) do
    body = %{
      query: %{
        match: %{
          agent_id: agent_id
        }
      }
    }

    case Elasticsearch.post(ElasticsearchCluster, "/logs/_search", body) do
      {:ok, response} ->
        {:ok, extract_content(response)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def extract_content(payload) do
    Enum.map(payload["hits"]["hits"], fn map -> map["_source"] end)
  end
end
