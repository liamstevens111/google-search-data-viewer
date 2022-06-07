defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_stats) do
    url_stats
    |> SearchResultUrl.changeset()
    |> Repo.insert()
  end

  def group_by_adword_types(search_result_urls) do
    search_result_urls
    |> Enum.group_by(&{&1.is_adword, &1.is_top_adword})
    |> Enum.map(&add_adword_type_from_group/1)
    |> Map.new()
  end

  defp add_adword_type_from_group({{true, true}, search_result_urls}),
    do: {:top_adwords, search_result_urls}

  defp add_adword_type_from_group({{false, false}, search_result_urls}),
    do: {:non_adwords, search_result_urls}

  defp add_adword_type_from_group({{true, false}, search_result_urls}),
    do: {:adwords, search_result_urls}
end
