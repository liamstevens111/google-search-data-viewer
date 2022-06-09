defmodule GoogleSearchDataViewerWeb.KeywordViewTest do
  use GoogleSearchDataViewerWeb.ConnCase, async: true

  alias GoogleSearchDataViewerWeb.KeywordView

  describe "total_urls/1" do
    test "given a list of search results containing three URLs, correctly returns the count" do
      search_results = %{
        top_adwords: [build(:search_result_top_adword_url)],
        adwords: [build(:search_result_adword_url)],
        non_adwords: [build(:search_result_normal_url)]
      }

      assert KeywordView.total_urls(search_results) == 3
    end
  end

  describe "format_date_time/1" do
    test "given a date and time, returns it in the format of d.m.y H:M:S" do
      {_, current_date_time} = NaiveDateTime.new(1970, 1, 1, 0, 0, 0)

      assert KeywordView.format_date_time(current_date_time) == "01.01.70 00:00:00"
    end
  end

  describe "total_urls/1" do
    test "given a list of search results containing three URLs, correctly returns the count" do
      search_results = %{
        top_adwords: [build(:search_result_top_adword_url)],
        adwords: [build(:search_result_adword_url)],
        non_adwords: [build(:search_result_normal_url)]
      }

      assert KeywordView.total_urls(search_results) == 3
    end
  end

  describe "count_search_result/2" do
    test "given a list of search results containing one Non Adword, correctly returns the count" do
      search_results = %{
        non_adwords: [build(:search_result_normal_url)]
      }

      assert KeywordView.count_search_result(search_results, :non_adwords) ==
               Enum.count(search_results.non_adwords)
    end

    test "given a list of search results containing top Adwords, correctly returns the count" do
      search_results = %{
        top_adwords: build_list(3, :search_result_top_adword_url)
      }

      assert KeywordView.count_search_result(search_results, :top_adwords) ==
               Enum.count(search_results.top_adwords)
    end
  end
end
