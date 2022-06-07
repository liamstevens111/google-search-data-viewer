defmodule GoogleSearchDataViewer.Keyword.Queries.KeywordsQuery do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  def list_for_user(user_id) do
    KeywordUpload
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> select([:id, :user_id, :name, :status, :updated_at, :inserted_at])
  end

  def get_keyword_upload_with_search_results(keyword_upload_id) do
    KeywordUpload
    |> preload(:search_result_urls)
    |> where([keyword], keyword.id == ^keyword_upload_id)
  end
end
