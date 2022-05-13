defmodule GoogleSearchDataViewer.Keywords.KeywordUpload do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload
  alias GoogleSearchDataViewer.Repo

  def do_create_keyword_uploads(attrs \\ %{}) do
    Repo.insert_all(KeywordUpload, attrs)
  end

  def create_keyword_uploads(keywords, user) do
    current_date_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    params =
      keywords
      |> Enum.map(fn keyword ->
        %{
          name: keyword,
          user_id: user.id
        }
      end)
      |> Enum.map(fn keyword -> KeywordUpload.changeset(%KeywordUpload{}, keyword) end)
      |> Enum.map(&Ecto.Changeset.apply_changes/1)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(fn keyword ->
        Map.drop(keyword, [:__meta__, :user, :id])
      end)
      |> Enum.map(fn keyword ->
        keyword
        |> Map.put(:inserted_at, current_date_time)
        |> Map.put(:updated_at, current_date_time)
      end)

    do_create_keyword_uploads(params)
  end
end
