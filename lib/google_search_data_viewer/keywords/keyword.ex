defmodule GoogleSearchDataViewer.Keywords.Keyword do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload
  alias GoogleSearchDataViewer.Repo

  def get_keyword_uploads_for_user(user) do
    KeywordUpload
    |> where(user_id: ^user.id)
    |> order_by(desc: :inserted_at)
    |> select([:name, :status, :updated_at, :inserted_at])
    |> Repo.all()
  end

  def insert_keyword_uploads(attrs) do
    Repo.insert_all(KeywordUpload, attrs)
  end

  def create_keyword_uploads(keywords, user) do
    keywords
    |> process_keyword_params(user)
    |> insert_keyword_uploads()
    |> elem(0)
  end

  defp process_keyword_params(keywords, user) do
    keywords
    |> Enum.map(fn keyword ->
      create_params_for_keyword_and_user(keyword, user.id)
    end)
    |> Enum.map(fn params -> create_changeset_and_parse(params) end)
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(fn params -> Map.drop(params, [:__meta__, :user, :id]) end)
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
