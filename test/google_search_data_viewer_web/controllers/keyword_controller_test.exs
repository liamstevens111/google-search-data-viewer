defmodule GoogleSearchDataViewerWeb.KeywordControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  describe "GET /keywords" do
    test "renders keywords page", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> get(Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Select a csv file to upload keywords"
    end
  end

  describe "POST /keywords/upload" do
    test "given a valid csv file extension, uploads the file", %{conn: conn} do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/valid_keywords.csv",
        filename: "valid_keywords.csv"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert get_flash(conn, :info) =~ "File successfully uploaded"
      assert redirected_to(conn, 302) =~ "/keywords"
    end

    test "given an unauthenticated user, fails to upload and redirects to the home page", %{conn: conn} do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/valid_keywords.csv",
        filename: "valid_keywords.csv"
      }

      conn = post(conn, "/keywords/upload", %{:file => file})

      assert conn.halted == true
      assert get_flash(conn, :error) =~ "Please sign in to use this service"
      assert redirected_to(conn, 302) =~ "/"
    end
  end
end
