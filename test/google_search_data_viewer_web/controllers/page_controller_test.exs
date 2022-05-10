defmodule GoogleSearchDataViewerWeb.PageControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Welcome to Google Search Data Viewer!"
    end
  end
end
