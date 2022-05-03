defmodule GoogleSearchDataViewerWeb.PutCurrentUserPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user = user_id && GoogleSearchDataViewer.Accounts.get_user(user_id)

    if user do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
