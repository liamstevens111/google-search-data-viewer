defmodule GoogleSearchDataViewerWeb.KeywordControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  describe "GET /keywords" do
    test "renders keywords page", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> get(Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Select a csv file for upload"
    end
  end

  describe "POST /keywords/upload" do
    test "given a valid csv file extention, uploads the file", %{conn: conn} do
      file = %Plug.Upload{
        path: "test/support/fixtures/keywords/keywords.csv",
        filename: "keywords.csv"
      }

      user = insert(:user)

      conn =
        conn
        |> init_test_session(user_id: user.id)
        |> post("/keywords/upload", %{:file => file})

      assert redirected_to(conn, 302) =~ "/keywords"
      assert get_flash(conn, :info) =~ "File successfully uploaded"
    end
  end
end
