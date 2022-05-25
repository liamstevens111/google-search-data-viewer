defmodule GoogleSearchDataViewer.Keywords.GoogleSearchClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias GoogleSearchDataViewer.Keywords.GoogleSearchClient

  setup_all do
    HTTPoison.start()
  end

  describe "get_html/1" do
    test "given a keyword, returns ok and body" do
      use_cassette "keywords/search_dog" do
        assert {:ok, _html_response} = GoogleSearchClient.get_html("dog")
      end
    end

    test "given a keyword and a server response with status code 500, returns error and description" do
      use_cassette :stub, url: "https://www.google.com/search?q=dog", status_code: 500 do
        assert {:error, "Internal server error"} = GoogleSearchClient.get_html("dog")
      end
    end
  end
end
