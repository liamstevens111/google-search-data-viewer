defmodule GoogleSearchDataViewer.SearchResultUrlDataFactory do
  alias Faker
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrlData

  defmacro __using__(_opts) do
    quote do
      def search_result_url_data_factory do
        %SearchResultUrlData{
          url: Faker.Internet.url(),
          is_adword: false,
          is_top_adword: false,
          keyword_upload: build(:keyword_upload)
        }
      end
    end
  end
end
