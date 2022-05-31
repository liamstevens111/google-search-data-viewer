defmodule GoogleSearchDataViewer.Keyword.GoogleSearchParserTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias GoogleSearchDataViewer.Keyword.GoogleSearchClient
  alias GoogleSearchDataViewer.Keyword.GoogleSearchParser

  setup do
    ExVCR.Config.cassette_library_dir(
      "test/support/fixtures/vcr_cassettes/keywords",
      "test/support/fixtures/vcr_cassettes/keywords/custom"
    )

    :ok
  end

  describe "get_url_statistics/1" do
    test "given a HTML response that contains a top adword, returns the URL" do
      use_cassette "search_buy_nike_shoes", custom: true do
        {:ok, html_response} = GoogleSearchClient.get_html("buy nike shoes")

        url_stats_results = GoogleSearchParser.get_url_statistics(html_response)

        assert Enum.member?(url_stats_results, %{
                 is_adword: true,
                 is_top_adword: true,
                 url: "https://www.nike.com/th/"
               })
      end
    end

    test "given a HTML response that contains a bottom adword, returns the URL" do
      use_cassette "search_galaxy_s21" do
        {:ok, html_response} = GoogleSearchClient.get_html("samsung galaxy s21")

        url_stats_results = GoogleSearchParser.get_url_statistics(html_response)

        assert Enum.member?(url_stats_results, %{
                 is_adword: true,
                 is_top_adword: false,
                 url: "https://www.powerbuy.co.th/th/promotion/brand-fair/android-fair?brand=OPPO"
               })
      end
    end

    test "given a HTML response that contains no adwords, returns list of URL data with no ads" do
      use_cassette "search_dog", custom: true do
        {:ok, html_response} = GoogleSearchClient.get_html("dog")

        url_stats_results = GoogleSearchParser.get_url_statistics(html_response)

        assert Enum.all?(url_stats_results, fn url_stats ->
                 url_stats.is_adword == false or url_stats.is_top_adword == false
               end)
      end
    end
  end
end
