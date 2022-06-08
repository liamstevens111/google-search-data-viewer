defmodule GoogleSearchDataViewer.Keyword.Queries.KeywordsQuery do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  def list_for_user(user_id) do
    KeywordUpload
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
  end
end
