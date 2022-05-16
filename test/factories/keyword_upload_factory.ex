defmodule GoogleSearchDataViewer.KeywordUploadFactory do
  alias Faker.Food.En
  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload

  defmacro __using__(_opts) do
    quote do
      def keyword_upload_factory(attrs) do
        name = attrs[:name] || En.dish()

        %KeywordUpload{
          name: name
        }
      end
    end
  end
end
