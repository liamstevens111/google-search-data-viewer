defmodule GoogleSearchDataViewerWorker.Keywords.SearchWorkerTest do
  use GoogleSearchDataViewer.DataCase, async: false

  alias GoogleSearchDataViewerWorker.Keywords.SearchWorker

  setup_all do
    HTTPoison.start()
  end

  describe "perform/1" do
    test "updates status to inprogress for the uploaded keyword" do
      use_cassette "keywords/search_iphone12" do
        user = insert(:user)
        keyword_upload = insert(:keyword_upload, name: "iphone 12", user: user)

        SearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword_upload.id}})

        keyword_upload_result = Repo.reload(keyword_upload)

        assert keyword_upload_result.status == :inprogress
      end
    end

    test "inserts html into the uploaded keyword" do
      use_cassette "keywords/search_iphone12" do
        user = insert(:user)
        keyword_upload = insert(:keyword_upload, name: "iphone 12", user: user)

        SearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword_upload.id}})

        keyword_upload_result = Repo.reload(keyword_upload)

        assert keyword_upload_result.html =~ "</html>"
      end
    end
  end
end
