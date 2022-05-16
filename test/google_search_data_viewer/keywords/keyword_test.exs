defmodule GoogleSearchDataViewer.Keywords.KeywordTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keywords.Keyword

  describe "create_keyword_uploads/2" do
    test "give a valid list of keywords and a user, creates keywords for the user" do
      user = insert(:user)
      keywords = ["dog", "cat", "fish"]

      assert Keyword.create_keyword_uploads(keywords, user) == Enum.count(keywords)
    end
  end
end
