defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Queries.KeywordsQuery
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_stats) do
    url_stats
    |> SearchResultUrl.changeset()
    |> Repo.insert()
  end

  def get_report_for_keyword_upload(keyword_upload_id) do
    keyword_upload_query = KeywordsQuery.list_for_keyword_with_search_results(keyword_upload_id)

    keyword_upload_urls_summary =
      keyword_upload_query
      |> KeywordsQuery.url_stats_by_search_results()
      |> Repo.all()
      |> Enum.map(fn summary -> add_name_to_url_row_summary(summary) end)

    keyword_upload = Repo.all(keyword_upload_query)

    %{
      keyword_upload: keyword_upload,
      keyword_upload_url_summary: keyword_upload_urls_summary
    }
  end

  defp add_name_to_url_row_summary(%{is_adword: nil, is_top_adword: nil, count: count}) do
    %{total_links: count}
  end

  defp add_name_to_url_row_summary(%{is_adword: true, is_top_adword: true, count: count}) do
    %{total_top_adwords: count}
  end

  defp add_name_to_url_row_summary(%{is_adword: false, is_top_adword: false, count: count}) do
    %{total_non_adwords: count}
  end

  defp add_name_to_url_row_summary(%{is_adword: true, is_top_adword: false, count: count}) do
    %{total_adwords: count}
  end
end
