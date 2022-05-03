defmodule GoogleSearchDataViewerWeb.AuthController do
  use GoogleSearchDataViewerWeb, :controller

  import Plug.Conn

  @spec sign_in(Plug.Conn.t(), atom | %{:id => any, optional(any) => any}) :: Plug.Conn.t()
  def sign_in(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
