defmodule GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl

  describe "changeset/2" do
    test "given a changeset with url, adword data and an existing keyword upload, validates" do
      %{id: keyword_upload_id} = insert(:keyword_upload)

      search_result_url_changeset =
        SearchResultUrl.changeset(%{
          url: "someurl@something.com",
          is_adword: true,
          is_top_adword: true,
          keyword_upload_id: keyword_upload_id
        })

      assert search_result_url_changeset.valid? == true

      assert search_result_url_changeset.changes == %{
               url: "someurl@something.com",
               is_adword: true,
               is_top_adword: true,
               keyword_upload_id: keyword_upload_id
             }
    end

    test "given an empty changeset with empty fields, fails to validate" do
      search_result_url_changeset = SearchResultUrl.changeset(%{})

      assert search_result_url_changeset.valid? == false
    end

    test "given an invalid keyword upload, return invalid changeset" do
      search_result_url_changeset =
        SearchResultUrl.changeset(%{
          url: "someurl@something.com",
          is_adword: true,
          is_top_adword: true,
          keyword_upload_id: -1
        })

      assert {:error, changeset} = Repo.insert(search_result_url_changeset)

      assert errors_on(changeset) == %{keyword_upload: ["does not exist"]}
    end
  end
end
