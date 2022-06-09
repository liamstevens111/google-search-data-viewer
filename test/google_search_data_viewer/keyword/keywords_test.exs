defmodule GoogleSearchDataViewer.Keyword.KeywordsTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.Keywords

  describe "create_keyword_uploads/2" do
    test "given a valid list of keywords and a user, creates keywords for the user" do
      user = insert(:user)
      keywords = ["dog", "cat", "fish"]

      {keyword_count, created_keywords} = Keywords.create_keyword_uploads(keywords, user)

      assert keyword_count == Enum.count(keywords)
      assert keywords == Enum.map(created_keywords, fn keyword -> keyword.name end)
    end
  end

  describe "get_keyword_uploads_for_user/1" do
    test "given an existing user with uploaded keywords, lists keywords for the user" do
      user = insert(:user)

      insert_list(3, :keyword_upload, user: user)

      assert Enum.count(Keywords.get_keyword_uploads_for_user(user)) == 3
    end

    test "given an existing user with no uploaded keywords, returns an empty list" do
      user_with_keywords = insert(:user)
      user_without_keywords = insert(:user)

      insert_list(3, :keyword_upload, user: user_with_keywords)

      assert Keywords.get_keyword_uploads_for_user(user_without_keywords) == []
    end
  end

  describe "get_keyword_upload/1" do
    test "with an existing uploaded keyword, returns the keyword upload for the given id" do
      keyword_upload = insert(:keyword_upload, name: "dog")

      assert keyword_upload ==
               keyword_upload.id |> Keywords.get_keyword_upload() |> Repo.preload(:user)
    end

    test "with a non-existing uploaded keyword, returns nil" do
      user = insert(:user)
      insert(:keyword_upload, name: "dog", user: user)

      assert Keywords.get_keyword_upload(-1) == nil
    end
  end

  describe "get_keyword_upload_with_search_results/1" do
    test "with an existing uploaded keyword and search results, returns the keyword upload with search results for the given id" do
      keyword_upload = insert(:keyword_upload)

      insert_list(3, :search_result_normal_url, keyword_upload: keyword_upload)

      keyword_upload_result = Keywords.get_keyword_upload_with_search_results(keyword_upload.id)

      assert Enum.count(keyword_upload_result.search_result_urls) == 3
    end

    test "with an existing uploaded keyword and no search results, returns the keyword upload with search results as an empty list for the given id" do
      keyword_upload = insert(:keyword_upload)
      other_keyword_upload = insert(:keyword_upload)

      insert(:search_result_normal_url, keyword_upload: other_keyword_upload)

      keyword_upload_result = Keywords.get_keyword_upload_with_search_results(keyword_upload.id)

      assert Enum.empty?(keyword_upload_result.search_result_urls)
    end
  end

  describe "update_keyword_upload_status/2" do
    test "given an existing uploaded keyword and a new status of inprogress, updates the status to inprogress" do
      keyword_upload = insert(:keyword_upload, name: "dog", status: :pending)

      {_, keyword_upload_result} =
        Keywords.update_keyword_upload_status(keyword_upload, :inprogress)

      assert keyword_upload_result.status == :inprogress
    end
  end

  describe "update_keyword_upload_html/2" do
    test "given an existing uploaded keyword and a non-empty html value, updates the html value" do
      keyword_upload = insert(:keyword_upload, name: "dog")

      html = "<html> </html>"

      {_, keyword_upload_result} = Keywords.update_keyword_upload_html(keyword_upload, html)

      assert keyword_upload_result.html == html
    end
  end
end
