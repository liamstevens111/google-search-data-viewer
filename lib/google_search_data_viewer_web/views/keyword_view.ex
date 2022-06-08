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

<<<<<<< HEAD
  def count_search_result(search_results, type) do
    search_results
    |> Map.get(type, [])
    |> Enum.count()
  end
=======
  def total_top_adword_urls(search_results),
    do: Enum.count(Map.get(search_results, :top_adwords, []))

  def total_adword_urls(search_results),
    do: Enum.count(Map.get(search_results, :adwords, []))

  def total_non_adword_urls(search_results),
    do: Enum.count(Map.get(search_results, :non_adwords, []))
>>>>>>> b5d3b10 ([#2] Add page for displaying URL results for the KeywordUpload)
end
