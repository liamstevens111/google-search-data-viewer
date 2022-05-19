defmodule GoogleSearchDataViewer.Keywords.KeywordTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keywords.Keyword

  describe "create_keyword_uploads/2" do
    test "given a valid list of keywords and a user, creates keywords for the user" do
      user = insert(:user)
      keywords = ["dog", "cat", "fish"]

      {keyword_count, _keywords} = Keyword.create_keyword_uploads(keywords, user)

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
               |> Keyword.get_keyword_uploads_for_user()
               |> Repo.preload(:user)
    end

    test "given an existing user with no uploaded keywords, returns an empty list" do
      user1 = insert(:user)
      user2 = insert(:user)

      keywords = ["dog", "cat", "fish"]

      Enum.each(keywords, fn keyword -> insert(:keyword_upload, name: keyword, user: user1) end)

      assert Keyword.get_keyword_uploads_for_user(user2) == []
    end
  end
end
