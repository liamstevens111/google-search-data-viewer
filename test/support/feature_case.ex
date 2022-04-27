defmodule GoogleSearchDataViewerWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
      use Wallaby.Feature
      use Mimic

      import GoogleSearchDataViewer.Factory
      import GoogleSearchDataViewerWeb.Gettext

      alias GoogleSearchDataViewer.Repo
      alias GoogleSearchDataViewerWeb.Endpoint
      alias GoogleSearchDataViewerWeb.Router.Helpers, as: Routes

      @moduletag :feature_test
    end
  end
end
