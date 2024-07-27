defmodule Backend.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :backend

  def url do
    Application.get_env(:backend, __MODULE__)[:url]
  end
end
