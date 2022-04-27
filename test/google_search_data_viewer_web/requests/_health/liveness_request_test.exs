defmodule GoogleSearchDataViewerWeb.LivenessRequestTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  test "returns 200", %{conn: conn} do
    conn =
      get(
        conn,
        "#{Application.get_env(:google_search_data_viewer, GoogleSearchDataViewerWeb.Endpoint)[:health_path]}/liveness"
      )

    assert response(conn, :ok) =~ "alive"
  end
end
