defmodule GoogleSearchDataViewerWorker.Keyword.KeywordsTest do
  use Oban.Testing, repo: GoogleSearchDataViewer.Repo
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewerWorker.Keyword.Keywords
  alias GoogleSearchDataViewerWorker.Keyword.KeywordSearchWorker

  @job_delay_in_seconds 3

  describe "create_keyword_upload_jobs_with_delay/1" do
    test "given two uploaded keywords and a delay, jobs are created in the oban_jobs table scheduled for the correct times for two keyword ids" do
      user = insert(:user)

      first_keyword_upload = insert(:keyword_upload, name: "dog", user: user)
      second_keyword_upload = insert(:keyword_upload, name: "cat", user: user)

      Keywords.create_keyword_upload_jobs_with_delay(
        [
          first_keyword_upload,
          second_keyword_upload
        ],
        @job_delay_in_seconds
      )

      delayed_time = DateTime.add(DateTime.utc_now(), @job_delay_in_seconds, :second)

      assert_enqueued(
        worker: KeywordSearchWorker,
        args: %{keyword_id: first_keyword_upload.id}
      )

      assert_enqueued(
        worker: KeywordSearchWorker,
        scheduled_at: delayed_time,
        args: %{keyword_id: second_keyword_upload.id}
      )
    end
  end
end
