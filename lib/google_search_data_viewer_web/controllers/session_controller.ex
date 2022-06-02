defmodule GoogleSearchDataViewerWeb.SessionController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Account.Accounts

  def new(conn, _params), do: render(conn, "new.html")

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.validate_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> GoogleSearchDataViewerWeb.AuthHelper.sign_in(user)
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
    |> GoogleSearchDataViewerWeb.AuthHelper.sign_out()
    |> put_flash(:info, "You have signed out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
