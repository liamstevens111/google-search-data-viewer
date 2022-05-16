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
  end
end
