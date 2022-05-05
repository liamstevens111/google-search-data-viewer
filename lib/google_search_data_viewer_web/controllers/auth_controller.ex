defmodule GoogleSearchDataViewerWeb.AuthController do
  use GoogleSearchDataViewerWeb, :controller

  import Plug.Conn

  @spec sign_in(Plug.Conn.t(), atom | %{:id => any, optional(any) => any}) :: Plug.Conn.t()
  def sign_in(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  @spec sign_out(Plug.Conn.t()) :: Plug.Conn.t()
  def sign_out(conn) do
    delete_session(conn, :user_id)
  end
end
