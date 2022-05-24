defmodule GoogleSearchDataViewer.Keywords.GoogleSearchClient do
  @base_url "https://www.google.com/search?q="
  @headers [
    {"User-Agent",
     "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36"}
  ]

  def get_html(keyword) do
    search_url = @base_url <> URI.encode(keyword)

    {:ok, response} = HTTPoison.get(search_url, @headers)

    {:ok, response.body}
  end
end
