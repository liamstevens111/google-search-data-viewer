defmodule GoogleSearchDataViewer.Accounts do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Accounts.Passwords
  alias GoogleSearchDataViewer.Accounts.User
  alias GoogleSearchDataViewer.Repo

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  def change_user(%User{} = user, attrs \\ %{}), do: User.changeset(user, attrs)

  def validate_email_and_password(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Passwords.verify_password(password, user.hashed_password) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end
end
