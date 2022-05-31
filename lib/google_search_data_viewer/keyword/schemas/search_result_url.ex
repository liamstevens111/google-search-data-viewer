defmodule GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl do
  use Ecto.Schema

  import Ecto.Changeset

  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  schema "search_result_urls" do
    field :url, :string
    field :is_adword, :boolean, default: false
    field :is_top_adword, :boolean, default: false

    belongs_to :keyword_upload, KeywordUpload

    timestamps()
  end

  def changeset(search_result_url \\ %__MODULE__{}, attrs) do
    search_result_url
    |> cast(attrs, [:url, :is_adword, :is_top_adword, :keyword_upload_id])
    |> validate_required([:url, :keyword_upload_id])
    |> assoc_constraint(:keyword_upload)
  end
end
