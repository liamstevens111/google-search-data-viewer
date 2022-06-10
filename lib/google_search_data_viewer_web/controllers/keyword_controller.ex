defmodule GoogleSearchDataViewerWeb.KeywordController do
  use GoogleSearchDataViewerWeb, :controller

  alias GoogleSearchDataViewer.Keyword.Keywords
  alias GoogleSearchDataViewer.Keyword.SearchResults
  alias GoogleSearchDataViewerWeb.KeywordHelper
  alias GoogleSearchDataViewerWorker.Keyword.Keywords, as: WorkerKeywords

  def index(conn, _params) do
    keywords = Keywords.get_keyword_uploads_for_user(conn.assigns.current_user)
    render(conn, "index.html", keywords: keywords)
  end

  def show(conn, %{"id" => id}) do
    keyword_upload = Keywords.get_keyword_upload_with_search_results(id)

    search_results = SearchResults.group_by_adword_types(keyword_upload.search_result_urls)

    render(conn, "show.html", keyword_upload: keyword_upload, search_results: search_results)
  end

  def upload(conn, %{"file" => file}) do
    case KeywordHelper.validate_and_parse_keyword_file(file) do
      {:ok, parsed_keywords} ->
        {keyword_count, keyword_uploads} =
          Keywords.create_keyword_uploads(parsed_keywords, conn.assigns.current_user)

        WorkerKeywords.create_keyword_upload_jobs_with_delay(keyword_uploads)

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
