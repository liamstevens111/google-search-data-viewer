defmodule GoogleSearchDataViewer.Keyword.SearchResultsTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.SearchResults

  describe "create_search_results/1" do
    test "given valid search result data, creates search result data for a keyword upload" do
      keyword_upload = insert(:keyword_upload)

      search_result_url_data = %{
        url: "www.google.com",
        is_top_adword: false,
        is_adword: true,
        keyword_upload_id: keyword_upload.id
      }

      {:ok, search_result} = SearchResults.create_search_results(search_result_url_data)

      assert search_result.url == "www.google.com"
      assert search_result.is_top_adword == false
      assert search_result.is_adword == true
      assert search_result.keyword_upload_id == keyword_upload.id
    end
  end
end
