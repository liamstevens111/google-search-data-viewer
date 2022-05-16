defmodule GoogleSearchDataViewer.Keywords.Keyword do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload
  alias GoogleSearchDataViewer.Repo

  def insert_keyword_uploads(attrs) do
    Repo.insert_all(KeywordUpload, attrs)
  end

  def create_keyword_uploads(keywords, user) do
    current_date_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    keywords
    |> Enum.map(fn keyword ->
      create_params_for_keyword_and_user(keyword, user.id)
    end)
    |> Enum.map(fn params -> create_changeset_and_parse(params) end)
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(fn params -> Map.drop(params, [:__meta__, :user, :id]) end)
    |> Enum.map(fn params -> insert_timestamps(params, current_date_time) end)
    |> insert_keyword_uploads()
    |> elem(0)
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

  defp insert_timestamps(params, time) do
    params
    |> Map.put(:inserted_at, time)
    |> Map.put(:updated_at, time)
  end
end
