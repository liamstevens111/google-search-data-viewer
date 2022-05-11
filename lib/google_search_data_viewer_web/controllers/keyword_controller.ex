defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  def index(conn, _params), do: render(conn, "index.html")

  def upload(conn, %{"file" => _file}) do
    conn
    |> put_flash(:info, "File successfully uploaded")
    |> redirect(to: Routes.keyword_path(conn, :index))
  end
end
