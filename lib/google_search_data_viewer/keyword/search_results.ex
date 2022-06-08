defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_stats) do
    url_stats
    |> SearchResultUrl.changeset()
    |> Repo.insert()
  end

  def group_by_adword_types(search_result_urls) do
    Enum.group_by(search_result_urls, &group_adword_type/1)
  end

  defp group_adword_type(%SearchResultUrl{is_adword: true, is_top_adword: true}), do: :top_adwords
  defp group_adword_type(%SearchResultUrl{is_adword: false, is_top_adword: false}), do: :non_adwords
  defp group_adword_type(%SearchResultUrl{is_adword: true, is_top_adword: false}), do: :adwords
end
