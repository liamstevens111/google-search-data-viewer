defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewerWeb.KeywordHelper

  def index(conn, _params), do: render(conn, "index.html")

  def upload(conn, %{"file" => file}) do
    case KeywordHelper.validate_and_parse_keyword_file(file) do
      {:ok, _keywords} ->
        conn
        |> put_flash(:info, "File successfully uploaded")
        |> redirect(to: Routes.keyword_path(conn, :index))

      {:error, :invalid_extension} ->
        conn
        |> put_flash(:error, "File extension invalid, csv only")
        |> redirect(to: Routes.keyword_path(conn, :index))
        |> halt()

      {:error, :invalid_length} ->
        conn
        |> put_flash(:error, "Length invalid. 1-1000 keywords only")
        |> redirect(to: Routes.keyword_path(conn, :index))
        |> halt()
    end
  end
end
