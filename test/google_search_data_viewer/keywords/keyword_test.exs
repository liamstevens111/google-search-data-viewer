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

      {_keyword_count, returned_keywords} = Keyword.create_keyword_uploads(keywords, user)

      assert Enum.map(returned_keywords, & &1.name) == keywords
      assert Keyword.get_keyword_uploads_for_user(user) == returned_keywords
    end

    test "given an existing user with no uploaded keywords, returns no keywords for the user" do
      user1 = insert(:user)
      user2 = insert(:user)

      keywords = ["dog", "cat", "fish"]

      Keyword.create_keyword_uploads(keywords, user1)

      assert Keyword.get_keyword_uploads_for_user(user2) == []
    end
  end
end
