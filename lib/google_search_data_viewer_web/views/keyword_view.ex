defmodule GoogleSearchDataViewerWeb.KeywordView do
  use GoogleSearchDataViewerWeb, :view

  def format_date_time(datetime) do
    Calendar.strftime(datetime, "%d.%m.%y %H:%M:%S")
  end

  def total_urls(search_results) do
    search_results
    |> Enum.map(fn {_, search_result_urls} -> Enum.count(search_result_urls) end)
    |> Enum.sum()
  end

  def count_search_result(search_results, type) do
    search_results
    |> Map.get(type, [])
    |> Enum.count()
  end
end
