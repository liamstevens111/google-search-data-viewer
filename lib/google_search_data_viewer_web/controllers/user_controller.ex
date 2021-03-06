defmodule GoogleSearchDataViewerWeb.UserController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Account.Accounts
  alias GoogleSearchDataViewer.Account.Schemas.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> GoogleSearchDataViewerWeb.AuthHelper.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
