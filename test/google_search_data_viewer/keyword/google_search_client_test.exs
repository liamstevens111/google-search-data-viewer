defmodule GoogleSearchDataViewer.Keyword.GoogleSearchClientTest do
  use GoogleSearchDataViewer.DataCase, async: false

  alias GoogleSearchDataViewer.Keyword.GoogleSearchClient

  describe "get_html/1" do
    test "given a keyword, returns ok and body" do
      use_cassette "keyword_without_adword" do
        assert {:ok, _html_response} = GoogleSearchClient.get_html("dog")
      end
    end

    test "given a keyword and a server response with status code 500, returns error and description" do
      use_cassette :stub, url: "https://www.google.com/search?q=dog", status_code: 500 do
        assert {:error, "Internal server error"} = GoogleSearchClient.get_html("dog")
      end
    end

    test "given a keyword and a server response with an unhandled status code 504, returns error and HTTPoison.Response" do
      use_cassette :stub, url: "https://www.google.com/search?q=dog", status_code: 504 do
        assert {:error, %HTTPoison.Response{}} = GoogleSearchClient.get_html("dog")
      end
    end
  end
end
