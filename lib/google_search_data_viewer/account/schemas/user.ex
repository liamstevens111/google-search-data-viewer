defmodule GoogleSearchDataViewer.Account.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias GoogleSearchDataViewer.Account.Passwords
  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string

    has_many :keyword_uploads, KeywordUpload

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:password, min: 12)
    |> unique_constraint(:email)
    |> hash_password(attrs)
  end

  defp hash_password(user, _attrs) do
    password = get_change(user, :password)

    user
    |> put_change(:hashed_password, Passwords.hash_password(password))
    |> delete_change(:password)
  end
end
