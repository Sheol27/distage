defmodule Backend.Elasticsearch do
  alias Backend.ElasticsearchCluster

  def search_documents(query) do
    body = %{
      query: %{
        match: %{
          _all: query
        }
      }
    }

    Elasticsearch.post(ElasticsearchCluster, "/logs/_search", body)
  end

  def get_documents(agent_id) do
    body = %{
      query: %{
        match: %{
          agent_id: agent_id
        }
      }
    }

    Elasticsearch.post(ElasticsearchCluster, "/logs/_search", body)
  end
end
