defmodule GoogleSearchDataViewerWeb.ReadinessRequestTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  test "returns 200", %{conn: conn} do
    conn =
      get(
        conn,
        "#{Application.get_env(:google_search_data_viewer, GoogleSearchDataViewerWeb.Endpoint)[:health_path]}/readiness"
      )

    assert response(conn, :ok) =~ "ready"
  end
end
