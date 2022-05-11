defmodule GoogleSearchDataViewer.Keywords.Schemas.KeywordUploadTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload

  describe "changeset/2" do
    test "given an empty changeset with empty fields, fails to validate" do
      keyword_upload_changeset = KeywordUpload.changeset(%KeywordUpload{}, %{})

      assert keyword_upload_changeset.valid? == false
    end
  end
end
