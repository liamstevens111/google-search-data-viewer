defmodule GoogleSearchDataViewer.Keyword.SearchResultsTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.SearchResults

  describe "create_search_results/1" do
    test "given valid search result data, creates search result data for a keyword upload" do
      keyword_upload = insert(:keyword_upload)

      search_result_url = %{
        url: "www.google.com",
        is_top_adword: false,
        is_adword: true,
        keyword_upload_id: keyword_upload.id
      }

      {:ok, search_result} = SearchResults.create_search_results(search_result_url)

      assert search_result.url == "www.google.com"
      assert search_result.is_top_adword == false
      assert search_result.is_adword == true
      assert search_result.keyword_upload_id == keyword_upload.id
    end

    test "given an empty url, returns an error" do
      keyword_upload = insert(:keyword_upload)

      search_result_url = %{
        url: "",
        keyword_upload_id: keyword_upload.id
      }

      {:error, changeset} = SearchResults.create_search_results(search_result_url)

      assert errors_on(changeset) == %{
               url: ["can't be blank"]
             }
    end

    test "given an invalid keyword upload, returns an error" do
      search_result_url = %{
        url: "www.google.com",
        keyword_upload_id: -1
      }

      {:error, changeset} = SearchResults.create_search_results(search_result_url)

      assert errors_on(changeset) == %{
               keyword_upload: ["does not exist"]
             }
    end
  end

  describe "group_by_adword_types/1" do
    test "given SearchResultUrls with two URLs that are not adwords, returns a Map with two non_adwords with the key non_adwords" do
      keyword_upload = insert(:keyword_upload)

      search_results = insert_list(2, :search_result_normal_url, keyword_upload: keyword_upload)

      result = SearchResults.group_by_adword_types(search_results)

      assert Map.has_key?(result, :adwords) == false
      assert Map.has_key?(result, :top_adwords) == false
      assert Enum.count(result.non_adwords) == 2
    end

    test "given SearchResultUrls with one URL that is an adword, returns a Map with one adword with the key adwords" do
      keyword_upload = insert(:keyword_upload)

      search_results = [
        insert(:search_result_adword_url,
          keyword_upload: keyword_upload
        )
      ]

      result = SearchResults.group_by_adword_types(search_results)

      assert Map.has_key?(result, :non_adwords) == false
      assert Map.has_key?(result, :top_adwords) == false
      assert Enum.count(result.adwords) == 1
    end

    test "given SearchResultUrls with two URLs that are top_adwords, returns a Map with two top_adwords with the key top_adwords" do
      keyword_upload = insert(:keyword_upload)

      search_results = insert_list(2, :search_result_top_adword_url, keyword_upload: keyword_upload)

      result = SearchResults.group_by_adword_types(search_results)

      assert Map.has_key?(result, :adwords) == false
      assert Map.has_key?(result, :non_adwords) == false
      assert Enum.count(result.top_adwords) == 2
    end

    test "given SearchResultUrls with two URLs that are a top_adword and adword, returns a Map with both keys" do
      keyword_upload = insert(:keyword_upload)

      search_results = [
        insert(:search_result_top_adword_url,
          keyword_upload: keyword_upload
        ),
        insert(:search_result_adword_url,
          keyword_upload: keyword_upload
        )
      ]

      result = SearchResults.group_by_adword_types(search_results)

      assert Map.has_key?(result, :non_adwords) == false
      assert Enum.count(result.adwords) == 1
      assert Enum.count(result.top_adwords) == 1
    end

    test "given SearchResultUrls with three URLs that are a top_adword, adword and non_adword returns a Map with all three keys" do
      keyword_upload = insert(:keyword_upload)

      search_results = [
        insert(:search_result_top_adword_url,
          keyword_upload: keyword_upload
        ),
        insert(:search_result_adword_url,
          keyword_upload: keyword_upload
        ),
        insert(:search_result_normal_url,
          keyword_upload: keyword_upload
        )
      ]

      result = SearchResults.group_by_adword_types(search_results)

      assert Enum.count(result.non_adwords) == 1
      assert Enum.count(result.adwords) == 1
      assert Enum.count(result.top_adwords) == 1
    end
  end
end
