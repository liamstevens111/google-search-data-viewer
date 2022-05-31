defmodule GoogleSearchDataViewer.SearchResultUrlFactory do
  alias Faker
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl

  defmacro __using__(_opts) do
    quote do
      def search_result_url_factory do
        %SearchResultUrl{
          url: Faker.Internet.url(),
          is_adword: false,
          is_top_adword: false,
          keyword_upload: build(:keyword_upload)
        }
      end
    end
  end
end
