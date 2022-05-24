defmodule GoogleSearchDataViewerWorker.Keywords.JobCreationHelperTest do
  use Oban.Testing, repo: GoogleSearchDataViewer.Repo
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewerWorker.Keywords.JobCreationHelper
  alias GoogleSearchDataViewerWorker.Keywords.SearchWorker

  @job_delay 3

  describe "create_keyword_upload_jobs_with_delay/1" do
    test "given two uploaded keywords and a delay, jobs are created in the oban_jobs table scheduled for the correct times for two keyword ids" do
      user = insert(:user)

      first_keyword_upload = insert(:keyword_upload, name: "dog", user: user)
      second_keyword_upload = insert(:keyword_upload, name: "cat", user: user)

      JobCreationHelper.create_keyword_upload_jobs_with_delay(
        [
          first_keyword_upload,
          second_keyword_upload
        ],
        @job_delay
      )

      delayed_time = DateTime.add(DateTime.utc_now(), @job_delay, :second)

      assert_enqueued(worker: SearchWorker, args: %{keyword_id: first_keyword_upload.id})

      assert_enqueued(
        worker: SearchWorker,
        scheduled_at: delayed_time,
        args: %{keyword_id: second_keyword_upload.id}
      )
    end
  end
end
