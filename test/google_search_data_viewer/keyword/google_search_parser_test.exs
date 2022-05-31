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

  test "given a HTML response that contains an ad, returns the URL" do
    use_cassette "search_buy_nike_shoes", custom: true do
      {:ok, html_response} = GoogleSearchClient.get_html("buy nike shoes")

      url_data_results = GoogleSearchParser.get_url_data_from_html(html_response)

      assert Enum.member?(url_data_results, %{
               is_adword: true,
               is_top_adword: true,
               url: "https://www.nike.com/th/"
             })
    end
  end

  test "given a HTML response that contains no ads, returns the empty list of URL data" do
    use_cassette "search_dog", custom: true do
      {:ok, html_response} = GoogleSearchClient.get_html("dog")

      url_data_results = GoogleSearchParser.get_url_data_from_html(html_response)

      assert Enum.all?(url_data_results, fn url_data ->
               url_data.is_adword == false or url_data.is_top_adword == false
             end)
    end
  end
end
