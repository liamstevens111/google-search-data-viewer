defmodule GoogleSearchDataViewerWeb.KeywordViewTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  alias GoogleSearchDataViewerWeb.KeywordView

  describe "format_date_time/1" do
    test "given a date and time, returns it in the format of d.m.y H:M:S" do
      {_, current_date_time} = NaiveDateTime.new(1970, 1, 1, 0, 0, 0)

      assert KeywordView.format_date_time(current_date_time) == "01.01.70 00:00:00"
    end
  end
end
