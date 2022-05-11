defmodule GoogleSearchDataViewerWeb.EnsureAuthenticatedPlugTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  alias GoogleSearchDataViewerWeb.EnsureAuthenticatedPlug

  describe "init/1" do
    test "returns given options" do
      assert EnsureAuthenticatedPlug.init([]) == []
    end
  end

  describe "call/2" do
    test "given an unauthenticated user, renders home page", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> fetch_flash()
        |> EnsureAuthenticatedPlug.call([])

      assert conn.assigns.current_user == nil
      assert conn.halted == true
      assert get_flash(conn, :error) =~ "Please sign in to use this service"
      assert redirected_to(conn, 302) =~ "/"
    end
  end
end
