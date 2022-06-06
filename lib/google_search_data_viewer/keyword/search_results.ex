defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl
  alias GoogleSearchDataViewer.Keyword.Queries.SearchResultsQuery
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_stats) do
    url_stats
    |> SearchResultUrl.changeset()
    |> Repo.insert()
  end

  def get_report_for_keyword_upload(keyword_upload_id) do
    keyword_upload_urls =
      keyword_upload_id
      |> SearchResultsQuery.get_search_results_for_keyword_upload()
      |> SearchResultsQuery.get_search_results_summary_data()
  end
end
