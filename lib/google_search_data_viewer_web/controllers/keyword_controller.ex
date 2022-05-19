defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Keywords.Keyword
  alias GoogleSearchDataViewerWeb.KeywordHelper

  def index(conn, _params) do
    keywords = Keyword.get_keyword_uploads_for_user(conn.assigns.current_user)
    render(conn, "index.html", keywords: keywords)
  end

  def upload(conn, %{"file" => file}) do
    case KeywordHelper.validate_and_parse_keyword_file(file) do
      {:ok, keywords} ->
        {keyword_count, _keywords} =
          Keyword.create_keyword_uploads(keywords, conn.assigns.current_user)

        conn
        |> put_flash(:info, "File successfully uploaded. #{keyword_count} keywords uploaded.")
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
