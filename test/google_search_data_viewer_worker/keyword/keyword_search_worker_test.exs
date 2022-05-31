defmodule GoogleSearchDataViewerWorker.Keyword.KeywordSearchWorkerTest do
  use GoogleSearchDataViewer.DataCase, async: false

  alias GoogleSearchDataViewerWorker.Keyword.KeywordSearchWorker

  @max_attempts 3

  setup_all do
    HTTPoison.start()
  end

  describe "perform/1" do
    test "updates status from pending to completed for the uploaded keyword" do
      use_cassette "keywords/search_galaxy_s21" do
        keyword_upload = insert(:keyword_upload, name: "samsung galaxy s21")

        KeywordSearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword_upload.id}})

        keyword_upload_result = Repo.reload(keyword_upload)

        assert keyword_upload_result.status == :completed
      end
    end

    test "inserts html into the uploaded keyword" do
      use_cassette "keywords/search_iphone12" do
        keyword_upload = insert(:keyword_upload, name: "iphone 12")

        KeywordSearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword_upload.id}})

        keyword_upload_result = Repo.reload(keyword_upload)

        assert keyword_upload_result.html =~ "</html>"
      end
    end

    test "updates status to failed when max attempts have been reached" do
      use_cassette "keywords/search_iphone12" do
        keyword_upload = insert(:keyword_upload, name: "iphone 12")

        KeywordSearchWorker.perform(%Oban.Job{
          args: %{"keyword_id" => keyword_upload.id},
          attempt: @max_attempts
        })

        %{status: keyword_status} = Repo.reload(keyword_upload)

        assert keyword_status == :failed
      end
    end
  end
end
