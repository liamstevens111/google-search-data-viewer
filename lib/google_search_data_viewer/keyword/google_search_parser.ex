defmodule GoogleSearchDataViewer.Keyword.GoogleSearchParser do
  @css_search_selectors %{
    top_adwords: "#tads > .uEierd a.sVXRqc",
    top_non_adwords: ".MhgNwc a",
    non_adwords: ".yuRUbf a",
    bottom_adwords: "#bottomads .uEierd a.sVXRqc"
  }

  def get_url_statistics(html) do
    {_, parsed_html} = Floki.parse_document(html)

    []
    |> prepend_top_adwords(parsed_html)
    |> prepend_top_non_adwords(parsed_html)
    |> prepend_non_adwords(parsed_html)
    |> prepend_bottom_adwords(parsed_html)
  end

  defp prepend_top_adwords(url_stats, parsed_html) do
    parsed_html
    |> Floki.find(@css_search_selectors.top_adwords)
    |> Floki.attribute("href")
    |> Enum.map(fn url -> %{url: url, is_adword: true, is_top_adword: true} end)
    |> Enum.concat(url_stats)
  end

  defp prepend_top_non_adwords(url_stats, parsed_html) do
    parsed_html
    |> Floki.find(@css_search_selectors.top_non_adwords)
    |> Floki.attribute("href")
    |> Enum.map(fn url -> %{url: url, is_adword: false, is_top_adword: false} end)
    |> Enum.concat(url_stats)
  end

  defp prepend_non_adwords(url_stats, parsed_html) do
    parsed_html
    |> Floki.find(@css_search_selectors.non_adwords)
    |> Floki.attribute("href")
    |> Enum.map(fn url -> %{url: url, is_adword: false, is_top_adword: false} end)
    |> Enum.concat(url_stats)
  end

  defp prepend_bottom_adwords(url_stats, parsed_html) do
    parsed_html
    |> Floki.find(@css_search_selectors.bottom_adwords)
    |> Floki.attribute("href")
    |> Enum.map(fn url -> %{url: url, is_adword: true, is_top_adword: false} end)
    |> Enum.concat(url_stats)
  end
end
