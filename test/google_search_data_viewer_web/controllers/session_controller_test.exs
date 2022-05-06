defmodule GoogleSearchDataViewerWeb.SessionControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  @valid_attrs %{email: "test@gmail.com", password: "aValidPasswordEntered"}

  describe "GET /sessions/new" do
    test "renders sign in page", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "POST /sessions" do
    test "given a pre-existing email and password, signs a user in", %{conn: conn} do
      insert(:user, email: @valid_attrs[:email], password: @valid_attrs[:password])

      conn =
        post conn, Routes.session_path(conn, :create), %{
          "email" => @valid_attrs[:email],
          "password" => @valid_attrs[:password]
        }

      assert get_session(conn, :user_id)
      assert redirected_to(conn, 302) =~ "/"
    end

    test "given a non-existing email and password, fail to sign the user in", %{conn: conn} do
      insert(:user, email: @valid_attrs[:email], password: @valid_attrs[:password])

      conn =
        post conn, Routes.session_path(conn, :create), %{
          "email" => "unknown@email.com",
          "password" => "somepassword"
        }

      assert get_session(conn, :user_id) == nil
      assert get_flash(conn, :error) =~ "Invalid email or password"
    end
  end

  describe "DELETE /sessions/:id" do
    test "when a user is signed in, sign the user out", %{conn: conn} do
      user = insert(:user, email: @valid_attrs[:email], password: @valid_attrs[:password])

      conn =
        post(conn, Routes.session_path(conn, :create), %{
          "email" => @valid_attrs[:email],
          "password" => @valid_attrs[:password]
        })

      assert get_session(conn, :user_id)
      assert redirected_to(conn, 302) =~ "/"

      signed_out_conn = delete(conn, Routes.session_path(conn, :delete, user))

      assert redirected_to(signed_out_conn) == "/"
      assert get_session(signed_out_conn, :user_token) == nil
      assert get_flash(signed_out_conn, :info) =~ "You have signed out"
    end
  end
end
