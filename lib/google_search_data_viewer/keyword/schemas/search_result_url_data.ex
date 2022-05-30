defmodule GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlData do
  use Ecto.Schema

  import Ecto.Changeset

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  schema "search_result_url_data" do
    field :url, :string
    field :is_adword, :boolean, default: false
    field :is_top_adword, :boolean, default: false

    belongs_to :keyword_upload, KeywordUpload

    timestamps()
  end

  def changeset(search_result_url_data \\ %__MODULE__{}, attrs) do
    search_result_url_data
    |> cast(attrs, [:url, :is_adword, :is_top_adword, :keyword_upload_id])
    |> validate_required([:url, :keyword_upload_id])
    |> assoc_constraint(:keyword_upload)
  end
end
