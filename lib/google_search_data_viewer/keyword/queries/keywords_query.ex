defmodule GoogleSearchDataViewer.Keyword.Queries.KeywordsQuery do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  def list_for_user(user_id) do
    KeywordUpload
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> select([:id, :user_id, :name, :status, :updated_at, :inserted_at])
  end

  def list_for_keyword_with_search_results(keyword_upload_id) do
    KeywordUpload
    |> join(:left, [keyword], url in assoc(keyword, :search_result_urls))
    |> preload(:search_result_urls)
    |> where([keyword], keyword.id == ^keyword_upload_id)
  end

  def url_stats_by_search_results(query) do
    query
    |> exclude(:preload)
    |> group_by([_, url], fragment("GROUPING SETS ((), (?, ?))", url.is_adword, url.is_top_adword))
    |> select([_, url], %{
      is_adword: url.is_adword,
      is_top_adword: url.is_top_adword,
      count: count()
    })
  end
end
