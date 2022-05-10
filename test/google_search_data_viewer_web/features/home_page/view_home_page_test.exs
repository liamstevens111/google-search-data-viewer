defmodule GoogleSearchDataViewerWeb.HomePage.ViewHomePageTest do
  use GoogleSearchDataViewerWeb.FeatureCase

  feature "view home page", %{session: session} do
    visit(session, Routes.page_path(GoogleSearchDataViewerWeb.Endpoint, :index))

    assert_has(session, Query.text("Welcome to Google Search Data Viewer!"))
  end
end
