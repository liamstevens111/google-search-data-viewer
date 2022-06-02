defmodule GoogleSearchDataViewerWorker.Keyword.Keywords do
  alias GoogleSearchDataViewerWorker.Keyword.KeywordSearchWorker

  def create_keyword_upload_jobs_with_delay(keyword_uploads, delay \\ 3) do
    keyword_uploads
    |> Enum.with_index()
    |> Enum.map(fn {keyword_upload, index} ->
      KeywordSearchWorker.new(%{keyword_id: keyword_upload.id}, schedule_in: index * delay)
    end)
    |> Oban.insert_all()
  end
end
