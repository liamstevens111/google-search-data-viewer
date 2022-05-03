defmodule GoogleSearchDataViewerWeb.UserControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  @create_attrs %{email: "some@email", password: "somepassword"}
  @invalid_attrs %{email: "someinvalidemail", password: "somepass"}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end
end
