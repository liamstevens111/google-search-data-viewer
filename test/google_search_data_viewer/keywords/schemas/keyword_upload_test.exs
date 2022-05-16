defmodule GoogleSearchDataViewer.Keywords.Schemas.KeywordUploadTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload

  describe "changeset/2" do
    test "given a changeset with keyword name and user id, returns valid changeset" do
      keyword_upload_changeset =
        KeywordUpload.changeset(%KeywordUpload{}, %{name: "cat", user_id: 1})

      assert keyword_upload_changeset.valid? == true
    end

    test "given an empty changeset with empty fields, fails to validate" do
      keyword_upload_changeset = KeywordUpload.changeset(%KeywordUpload{}, %{})

      assert keyword_upload_changeset.valid? == false
    end

    test "given a changeset with keyword name and existing user id, validates" do
      %{id: user_id} = insert(:user)

      keyword_upload_changeset =
        KeywordUpload.changeset(%KeywordUpload{}, %{name: "cat", user_id: user_id})

      assert keyword_upload_changeset.valid? == true
      assert keyword_upload_changeset.changes == %{name: "cat", user_id: user_id}
    end

    test "given an invalid user, return invalid changeset" do
      keyword_upload_changeset =
        KeywordUpload.changeset(%KeywordUpload{}, %{name: "cat", user_id: -1})

      assert {:error, changeset} = Repo.insert(keyword_upload_changeset)

      assert errors_on(changeset) == %{user: ["does not exist"]}
    end
  end
end
