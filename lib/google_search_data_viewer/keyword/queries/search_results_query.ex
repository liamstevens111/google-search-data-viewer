defmodule GoogleSearchDataViewer.Keyword.Queries.SearchResultsQuery do
  import Ecto.Query

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  def list_completed() do
  end

  def get_search_results_for_keyword_upload(keyword_upload_id) do
    KeywordUpload
    |> join(:left, [keyword], url in assoc(keyword, :search_result_urls))
    |> preload(:search_result_urls)
    |> where([keyword], keyword.id == ^keyword_upload_id)
  end

  def get_search_results_summary_data(query) do
    query
    |> exclude(:preload)
    |> group_by([keyword, url], fragment("GROUPING SETS ((), (?, ?))", url.is_adword, url.is_top_adword))
    |> select([keyword, url], {url.is_adword, url.is_top_adword, count()})
  end
end
