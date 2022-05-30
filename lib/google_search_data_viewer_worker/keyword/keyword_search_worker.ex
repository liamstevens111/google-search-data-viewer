defmodule GoogleSearchDataViewerWorker.Keyword.KeywordSearchWorker do
  use Oban.Worker,
    queue: :keyword_search,
    max_attempts: 3,
    unique: [period: 30]

  alias GoogleSearchDataViewer.Keyword.GoogleSearchClient
  alias GoogleSearchDataViewer.Keyword.GoogleSearchParser
  alias GoogleSearchDataViewer.Keyword.Keywords
  alias GoogleSearchDataViewer.Keyword.SearchResults

  @max_attempts 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}, attempt: @max_attempts}) do
    {:ok, _} =
      keyword_id
      |> Keywords.get_keyword_upload()
      |> Keywords.update_keyword_upload_status(:failed)

    {:error, "max attempts reached, attempt: #{@max_attempts}"}
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    {_, keyword_upload} =
      keyword_id
      |> Keywords.get_keyword_upload()
      |> Keywords.update_keyword_upload_status(:inprogress)

    {:ok, html_response} = GoogleSearchClient.get_html(keyword_upload.name)

    {:ok, _} = Keywords.update_keyword_upload_html(keyword_upload, html_response)

    GoogleSearchParser.get_url_data_from_html(html_response)
    |> Enum.map(fn data -> Map.put(data, :keyword_upload_id, keyword_upload.id) end)
    |> Enum.map(fn data -> SearchResults.create_search_results(data) end)

    :ok
  end
end
