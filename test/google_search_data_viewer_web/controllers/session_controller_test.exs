defmodule GoogleSearchDataViewerWeb.SessionControllerTest do
  use GoogleSearchDataViewerWeb.ConnCase

  @valid_attrs %{email: "test@gmail.com", password: "aValidPasswordEntered"}

  describe "POST create/2" do
    test "signs a user in given correct email and password", %{conn: conn} do
      insert(:user, email: @valid_attrs[:email], password: @valid_attrs[:password])

      conn =
        post conn, Routes.session_path(conn, :create), %{
          "email" => @valid_attrs[:email],
          "password" => @valid_attrs[:password]
        }

      assert get_session(conn, :user_id)
      assert redirected_to(conn, 302) =~ "/"
    end

    test "failed user sign in given incorrect email and password", %{conn: conn} do
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

  describe "DELETE create/2" do
    test "when user is signed in, signs a user out", %{conn: conn} do
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
