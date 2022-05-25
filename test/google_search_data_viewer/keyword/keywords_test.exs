defmodule GoogleSearchDataViewer.Keyword.KeywordsTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.Keywords

  describe "create_keyword_uploads/2" do
    test "given a valid list of keywords and a user, creates keywords for the user" do
      user = insert(:user)
      keywords = ["dog", "cat", "fish"]

      {keyword_count, _keywords} = Keywords.create_keyword_uploads(keywords, user)

      assert keyword_count == Enum.count(keywords)
    end
  end

  describe "get_keyword_uploads_for_user/1" do
    test "given an existing user with uploaded keywords, lists keywords for the user" do
      user = insert(:user)

      keywords = ["dog", "cat", "fish"]

      keyword_uploads =
        Enum.map(keywords, fn keyword -> insert(:keyword_upload, name: keyword, user: user) end)

      assert keyword_uploads ==
               user
               |> Keywords.get_keyword_uploads_for_user()
               |> Repo.preload(:user)
    end

    test "given an existing user with no uploaded keywords, returns an empty list" do
      user1 = insert(:user)
      user2 = insert(:user)

      keywords = ["dog", "cat", "fish"]

      Enum.each(keywords, fn keyword -> insert(:keyword_upload, name: keyword, user: user1) end)

      assert Keywords.get_keyword_uploads_for_user(user2) == []
    end
  end

  describe "get_keyword_upload/1" do
    test "with an existing uploaded keyword, returns the keyword upload for the given id" do
      user = insert(:user)
      keyword_upload = insert(:keyword_upload, name: "dog", user: user)

      assert keyword_upload ==
               keyword_upload.id |> Keywords.get_keyword_upload() |> Repo.preload(:user)
    end

    test "with a non-existing uploaded keyword, returns nil" do
      user = insert(:user)
      insert(:keyword_upload, name: "dog", user: user)

      assert Keywords.get_keyword_upload(-1) == nil
    end
  end

  describe "update_keyword_upload_status/2" do
    test "given an existing uploaded keyword and a new status of inprogress, updates the status to inprogress" do
      user = insert(:user)
      keyword_upload = insert(:keyword_upload, name: "dog", status: :pending, user: user)

      {_, keyword_upload_result} =
        Keywords.update_keyword_upload_status(keyword_upload, :inprogress)

      assert keyword_upload_result.status == :inprogress
    end
  end

  describe "update_keyword_upload_html/2" do
    test "given an existing uploaded keyword and a non-empty html value, updates the html value" do
      user = insert(:user)
      keyword_upload = insert(:keyword_upload, name: "dog", user: user)

      html = "<html> </html>"

      {_, keyword_upload_result} = Keywords.update_keyword_upload_html(keyword_upload, html)

      assert keyword_upload_result.html == html
    end
  end
end
