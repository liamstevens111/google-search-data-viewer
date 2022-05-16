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
        filename: "valid_keywords.csv",
        content_type: "text/csv"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert get_flash(conn, :info) =~ "File successfully uploaded"
      assert redirected_to(conn, 302) =~ "/keywords"
    end

    test "given a valid csv file extension with two keywords, returns an uploaded count of two", %{
      conn: conn
    } do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/valid_two_keywords.csv",
        filename: "valid_two_keywords.csv",
        content_type: "text/csv"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert get_flash(conn, :info) =~ "File successfully uploaded. 2 keywords uploaded"
      assert redirected_to(conn, 302) =~ "/keywords"
    end

    test "given an empty keywords file, fails to upload the file", %{conn: conn} do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/empty_keywords.csv",
        filename: "empty_keywords.csv",
        content_type: "text/csv"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert conn.halted == true
      assert get_flash(conn, :error) =~ "Length invalid. 1-1000 keywords only"
      assert redirected_to(conn, 302) =~ "/keywords"
    end

    test "given an invalid file extension, fails to upload the file", %{conn: conn} do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/invalid_extension_keywords.txt",
        filename: "invalid_extension_keywords.txt",
        content_type: "text/plain"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert conn.halted == true
      assert get_flash(conn, :error) =~ "File extension invalid, csv only"
      assert redirected_to(conn, 302) =~ "/keywords"
    end

    test "given an unauthenticated user, fails to upload and redirects to the home page", %{
      conn: conn
    } do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/valid_keywords.csv",
        filename: "valid_keywords.csv",
        content_type: "text/csv"
      }

      conn = post(conn, "/keywords/upload", %{:file => file})

      assert conn.halted == true
      assert get_flash(conn, :error) =~ "Please sign in to use this service"
      assert redirected_to(conn, 302) =~ "/"
    end
  end
end
