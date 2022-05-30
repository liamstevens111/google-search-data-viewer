defmodule GoogleSearchDataViewer.Keyword.GoogleSearchParser do
  @css_search_selectors %{
    top_adwords: "#tads > .uEierd a.sVXRqc[href]",
    top_sub_adwords: ".MhgNwc a[href]",
    non_adwords: ".yuRUbf a[href]",
    bottom_adwords: "#bottomads .uEierd a.sVXRqc[href]"
  }

  def get_url_data_from_html(html) do
    {_, parsed_html} = Floki.parse_document(html)

    url_data =
      []
      |> prepend_top_adwords(parsed_html)
      |> prepend_top_sub_adwords(parsed_html)
      |> prepend_non_adwords(parsed_html)
      |> prepend_bottom_adwords(parsed_html)

    url_data
  end

  defp prepend_top_adwords(url_data, html) do
    Enum.map(
      html
      |> Floki.find(@css_search_selectors.top_adwords)
      |> Floki.attribute("href"),
      fn url -> %{url: url, is_adword: true, is_top_adword: true} end
    ) ++
      url_data
  end

  defp prepend_top_sub_adwords(url_data, html) do
    Enum.map(
      html
      |> Floki.find(@css_search_selectors.top_sub_adwords)
      |> Floki.attribute("href"),
      fn url -> %{url: url, is_adword: false, is_top_adword: false} end
    ) ++
      url_data
  end

  defp prepend_non_adwords(url_data, html) do
    Enum.map(
      html
      |> Floki.find(@css_search_selectors.non_adwords)
      |> Floki.attribute("href"),
      fn url -> %{url: url, is_adword: false, is_top_adword: false} end
    ) ++
      url_data
  end

  defp prepend_bottom_adwords(url_data, html) do
    Enum.map(
      html
      |> Floki.find(@css_search_selectors.bottom_adwords)
      |> Floki.attribute("href"),
      fn url -> %{url: url, is_adword: true, is_top_adword: false} end
    ) ++
      url_data
  end
end
