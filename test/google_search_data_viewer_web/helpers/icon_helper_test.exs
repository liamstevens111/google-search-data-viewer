defmodule GoogleSearchDataViewerWeb.IconHelperTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

  alias GoogleSearchDataViewerWeb.IconHelper

  describe "icon_tag/3" do
    test "renders a svg icon" do
      image =
        GoogleSearchDataViewerWeb.Endpoint
        |> IconHelper.icon_tag("active", class: "customize-icon-class")
        |> safe_to_string()

      assert image ==
               "<svg class=\"icon customize-icon-class\"><use xlink:href=\"/images/icon-sprite.svg#active\"></svg>"
    end
  end
end
