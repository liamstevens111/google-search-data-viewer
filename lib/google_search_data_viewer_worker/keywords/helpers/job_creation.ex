defmodule GoogleSearchDataViewerWorker.Keywords.JobCreationHelper do
  alias GoogleSearchDataViewerWorker.Keywords.SearchWorker

  def create_keyword_upload_jobs_with_delay(keyword_uploads) do
    keyword_uploads
    |> Enum.zip_with(
      Enum.map(Enum.to_list(0..Enum.count(keyword_uploads)), &(&1 * 3)),
      fn keyword_upload, interval ->
        SearchWorker.new(%{keyword_id: keyword_upload.id, interval_in: interval})
      end
    )
    |> Oban.insert_all()
  end
end
