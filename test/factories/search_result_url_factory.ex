defmodule GoogleSearchDataViewer.SearchResultUrlFactory do
  alias Faker
  alias GoogleSearchDataViewer.Keyword.Schemas.SearchResultUrl

  defmacro __using__(_opts) do
    quote do
      def search_result_normal_url_factory do
        %SearchResultUrl{
          url: Faker.Internet.url(),
          is_adword: false,
          is_top_adword: false,
          keyword_upload: build(:keyword_upload)
        }
      end

      def search_result_top_adword_url_factory do
        struct!(
          search_result_normal_url_factory(),
          %{is_top_adword: true, is_adword: true}
        )
      end

      def search_result_adword_url_factory do
        struct!(
          search_result_normal_url_factory(),
          %{is_adword: true}
        )
      end
    end
  end
end
