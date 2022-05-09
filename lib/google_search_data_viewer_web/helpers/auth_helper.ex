defmodule GoogleSearchDataViewerWeb.AuthHelper do
  use GoogleSearchDataViewerWeb, :controller

  import Plug.Conn

  def sign_in(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def sign_out(conn), do: delete_session(conn, :user_id)
end
