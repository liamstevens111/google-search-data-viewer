# coveralls-ignore-start
defmodule GoogleSearchDataViewerWeb.EnsureAuthenticatedPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias GoogleSearchDataViewerWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user = user_id && GoogleSearchDataViewer.Accounts.get_user(user_id)

    if user do
      conn
    else
      conn
      |> assign(:current_user, nil)
      |> put_flash(:error, "Please sign in to use this service")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    end
  end
end

# coveralls-ignore-stop
