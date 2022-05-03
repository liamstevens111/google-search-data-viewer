defmodule GoogleSearchDataViewerWeb.SessionController do
  use GoogleSearchDataViewerWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case GoogleSearchDataViewer.Accounts.validate_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> GoogleSearchDataViewerWeb.AuthController.sign_in(user)
        |> put_flash(:info, "Welcome, you have signed in!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> GoogleSearchDataViewerWeb.AuthController.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
