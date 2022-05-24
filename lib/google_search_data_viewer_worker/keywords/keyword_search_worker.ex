defmodule GoogleSearchDataViewerWorker.Keywords.SearchWorker do
  use Oban.Worker,
    queue: :keyword_search,
    max_attempts: 3,
    unique: [period: 30]

  alias GoogleSearchDataViewer.Keywords.GoogleSearchClient
  alias GoogleSearchDataViewer.Keywords.Keyword

  @max_attempts 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}, attempt: @max_attempts}) do
    {:ok, _} =
      keyword_id
      |> Keyword.get_keyword_upload()
      |> Keyword.update_keyword_upload_status(:failed)

    {:error, "max attempts reached, attempt: #{@max_attempts}"}
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword_upload = Keyword.get_keyword_upload(keyword_id)

    {:ok, _} = Keyword.update_keyword_upload_status(keyword_upload, :inprogress)

    {:ok, html_response} = GoogleSearchClient.get_html(keyword_upload.name)

    {:ok, _} = Keyword.insert_keyword_upload_html(keyword_upload, html_response)

    :ok
  end
end
