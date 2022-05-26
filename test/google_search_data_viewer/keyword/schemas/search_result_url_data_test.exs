defmodule GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlDataTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlData

  describe "changeset/2" do
    test "given a changeset with url, adword data and an existing keyword upload, validates" do
      %{id: keyword_upload_id} = insert(:keyword_upload)

      search_result_url_data_changeset =
        SearchResultUrlData.changeset(%{
          url: "someurl@something.com",
          is_adword: true,
          is_top_adword: true,
          keyword_upload_id: keyword_upload_id
        })

      assert search_result_url_data_changeset.valid? == true

      assert search_result_url_data_changeset.changes == %{
               url: "someurl@something.com",
               is_adword: true,
               is_top_adword: true,
               keyword_upload_id: keyword_upload_id
             }
    end

    test "given an empty changeset with empty fields, fails to validate" do
      search_result_url_data_changeset = SearchResultUrlData.changeset(%{})

      assert search_result_url_data_changeset.valid? == false
    end

    test "given an invalid keyword upload, return invalid changeset" do
      search_result_url_data_changeset =
        SearchResultUrlData.changeset(%{
          url: "someurl@something.com",
          is_adword: true,
          is_top_adword: true,
          keyword_upload_id: -1
        })

      assert {:error, changeset} = Repo.insert(search_result_url_data_changeset)

      assert errors_on(changeset) == %{keyword_upload: ["does not exist"]}
    end
  end
end
