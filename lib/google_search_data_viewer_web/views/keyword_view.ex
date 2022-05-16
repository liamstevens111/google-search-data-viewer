defmodule GoogleSearchDataViewerWeb.KeywordView do
  use GoogleSearchDataViewerWeb, :view

  def format_date_time(datetime) do
    Calendar.strftime(datetime, "%d.%m.%y %H:%M:%S")
  end
end
