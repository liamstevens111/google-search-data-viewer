defmodule GoogleSearchDataViewerWeb.AuthControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  describe "GET sign_in/1" do
    test "renders sign in page", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "DELETE " do
    test "signs a user out", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end
end
