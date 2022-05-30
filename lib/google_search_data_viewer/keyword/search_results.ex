defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlData
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_data) do
    url_data
    |> SearchResultUrlData.changeset()
    |> Repo.insert()
  end
end
