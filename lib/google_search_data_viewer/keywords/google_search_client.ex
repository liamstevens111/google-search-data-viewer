defmodule GoogleSearchDataViewer.Keywords.GoogleSearchClient do
  @base_url "https://www.google.com/search?q="
  @headers [
    {"User-Agent",
     "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36"}
  ]

  def search_and_fetch_html(keyword) do
    search_url = @base_url <> URI.encode(keyword)

    case HTTPoison.get(search_url, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
