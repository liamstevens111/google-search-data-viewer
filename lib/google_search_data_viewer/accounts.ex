defmodule GoogleSearchDataViewer.Accounts do
  import Ecto.Query, warn: false

  alias GoogleSearchDataViewer.Accounts.Passwords
  alias GoogleSearchDataViewer.Accounts.User
  alias GoogleSearchDataViewer.Repo

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  def validate_email_and_password(email, password) do
    with %User{} = user <- get_user_by_email(email),
         true <- Passwords.verify_password(password, user.hashed_password) do
      {:ok, user}
    else
      nil ->
        Bcrypt.no_user_verify()
        {:error, :not_found}

      false ->
        {:error, :unauthorized}
    end
  end

  defp get_user_by_email(email), do: Repo.get_by(User, email: email)
end
