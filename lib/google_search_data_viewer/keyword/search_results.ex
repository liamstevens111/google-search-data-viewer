defmodule GoogleSearchDataViewer.Keyword.SearchResults do
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl
  alias GoogleSearchDataViewer.Repo

  def create_search_results(url_data) do
    url_data
    |> SearchResultUrl.changeset()
    |> Repo.insert()
  end
end
