defmodule GoogleSearchDataViewerWeb.EnsureAuthenticatedPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias GoogleSearchDataViewer.Accounts.Account
  alias GoogleSearchDataViewerWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_session(:user_id)
    |> get_user()
    |> case do
      nil ->
        conn
        |> assign(:current_user, nil)
        |> put_flash(:error, "Please sign in to use this service")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()

      _user ->
        conn
    end
  end

  defp get_user(nil), do: nil

  defp get_user(user_id), do: Account.get_user(user_id)
end
