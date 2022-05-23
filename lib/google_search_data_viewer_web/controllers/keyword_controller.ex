defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Keywords.Keyword
  alias GoogleSearchDataViewerWeb.KeywordHelper
  alias GoogleSearchDataViewerWorker.Keywords.JobCreationHelper

  def index(conn, _params) do
    keywords = Keyword.get_keyword_uploads_for_user(conn.assigns.current_user)
    render(conn, "index.html", keywords: keywords)
  end

  def upload(conn, %{"file" => file}) do
    case KeywordHelper.validate_and_parse_keyword_file(file) do
      {:ok, parsed_keywords} ->
        {keyword_count, keyword_uploads} =
          Keyword.create_keyword_uploads(parsed_keywords, conn.assigns.current_user)

        JobCreationHelper.create_keyword_upload_jobs_with_delay(keyword_uploads)

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
