defmodule GoogleSearchDataViewerWeb.KeywordHelper do
  alias NimbleCSV.RFC4180, as: CSV

  @max_keyword_upload_count 1000

  def validate_and_parse_keyword_file(file) do
    with true <- file_valid?(file),
         {:ok, keywords} <- parse_keyword_file(file) do
      {:ok, keywords}
    else
      false -> {:error, :invalid_format}
      :error -> {:error, :invalid_length}
    end
  end

  defp file_valid?(file), do: file.content_type == "text/csv"

  defp parse_keyword_file(file) do
    keywords =
      file.path
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.to_list()
      |> List.flatten()

    keywords_length = length(keywords)

    if keywords_length > 0 && keywords_length <= @max_keyword_upload_count do
      {:ok, keywords}
    else
      :error
    end
  end
end
