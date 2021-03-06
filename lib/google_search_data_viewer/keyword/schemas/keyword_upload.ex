defmodule GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload do
  use Ecto.Schema

  import Ecto.Changeset

  alias GoogleSearchDataViewer.Account.Schemas.User
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl

  schema "keyword_uploads" do
    field :name, :string
    field :html, :string

    field :status, Ecto.Enum,
      values: [:pending, :inprogress, :completed, :failed],
      default: :pending

    has_many :search_result_urls, SearchResultUrl
    belongs_to :user, User

    timestamps()
  end

  def changeset(keyword_upload \\ %__MODULE__{}, attrs) do
    keyword_upload
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> assoc_constraint(:user)
  end

  def html_changeset(keyword_upload \\ %__MODULE__{}, html) do
    keyword_upload
    |> cast(html, [:html])
    |> validate_required([:html])
  end

  def status_changeset(keyword_upload \\ %__MODULE__{}, status) do
    change(keyword_upload, status: status)
  end
end
