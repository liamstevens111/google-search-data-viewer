defmodule GoogleSearchDataViewerWeb.UserControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  @valid_attrs %{email: "some@email", password: "somepassword"}
  @invalid_attrs %{email: "someinvalidemail", password: "somepass"}

  describe "GET /users/new" do
    test "renders sign up page", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))

      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "POST /users" do
    test "given a valid email and password, redirects to home page and shows flash", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @valid_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) =~ "User created successfully"
    end

    test "given an invalid email and pasword, renders an error", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "something went wrong"
    end
  end
end
