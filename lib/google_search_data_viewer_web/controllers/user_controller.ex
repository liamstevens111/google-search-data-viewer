defmodule GoogleSearchDataViewerWeb.UserController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Accounts
  alias GoogleSearchDataViewer.Accounts.User
  alias GoogleSearchDataViewerWeb.AuthController

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> AuthController.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
