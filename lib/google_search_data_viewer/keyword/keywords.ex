defmodule GoogleSearchDataViewer.Keyword.Keywords do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keyword.Queries.KeywordsQuery
  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload
  alias GoogleSearchDataViewer.Repo

  def get_keyword_upload(id), do: Repo.get(KeywordUpload, id)

  def get_keyword_uploads_for_user(user) do
    user.id
    |> KeywordsQuery.list_for_user()
    |> Repo.all()
  end

  def get_keyword_upload_with_search_results(keyword_upload_id) do
    keyword_upload_id
    |> KeywordsQuery.get_keyword_upload_with_search_results()
    |> Repo.one()
  end

  def update_keyword_upload_status(keyword_upload, status) do
    keyword_upload
    |> KeywordUpload.status_changeset(status)
    |> Repo.update()
  end

  def update_keyword_upload_html(keyword_upload, html) do
    keyword_upload
    |> KeywordUpload.html_changeset(%{html: html})
    |> Repo.update()
  end

  def insert_keyword_uploads(attrs) do
    Repo.insert_all(KeywordUpload, attrs, returning: true)
  end

  def create_keyword_uploads(keywords, user) do
    keywords
    |> process_keyword_params(user)
    |> insert_keyword_uploads()
  end

  defp process_keyword_params(keywords, user) do
    keywords
    |> Enum.map(fn keyword ->
      create_params_for_keyword_and_user(keyword, user.id)
    end)
    |> Enum.map(fn params -> create_changeset_and_parse(params) end)
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(fn params -> Map.drop(params, [:__meta__, :user, :id, :search_result_urls]) end)
    |> Enum.map(fn params -> insert_timestamps(params) end)
  end

  defp create_params_for_keyword_and_user(keyword, user_id) do
    %{
      name: keyword,
      user_id: user_id
    }
  end

  defp create_changeset_and_parse(params) do
    params
    |> KeywordUpload.changeset()
    |> Ecto.Changeset.apply_changes()
  end

  defp insert_timestamps(params) do
    current_date_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    params
    |> Map.put(:inserted_at, current_date_time)
    |> Map.put(:updated_at, current_date_time)
  end
end
