defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Keywords.Keyword
  alias GoogleSearchDataViewerWeb.KeywordHelper

  def index(conn, _params), do: render(conn, "index.html")

  def upload(conn, %{"file" => file}) do
    case KeywordHelper.validate_and_parse_keyword_file(file) do
      {:ok, keywords} ->
        keywords_inserted = Keyword.create_keyword_uploads(keywords, conn.assigns.current_user)

        conn
        |> put_flash(:info, "File successfully uploaded. #{keywords_inserted} keywords uploaded.")
        |> redirect(to: Routes.keyword_path(conn, :index))

      {:error, :invalid_extension} ->
        conn
        |> put_flash(:error, "File extension invalid, csv only")
        |> redirect(to: Routes.keyword_path(conn, :index))

      {:error, :invalid_length} ->
        conn
        |> put_flash(:error, "Length invalid. 1-1000 keywords only")
        |> redirect(to: Routes.keyword_path(conn, :index))
    end
  end
end
