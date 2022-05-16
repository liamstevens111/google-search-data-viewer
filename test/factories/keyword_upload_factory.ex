defmodule GoogleSearchDataViewer.KeywordUploadFactory do
  alias GoogleSearchDataViewer.Keywords.Schemas.KeywordUpload

  defmacro __using__(_opts) do
    quote do

      def keyword_upload_factory(attrs) do
        name = attrs[:name] || Faker.Food.En.dish

        %KeywordUpload{
          name: name
        }
      end
    end
  end
end
