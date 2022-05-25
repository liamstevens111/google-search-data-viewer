defmodule GoogleSearchDataViewer.KeywordUploadFactory do
  alias Faker.Food.En
  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  defmacro __using__(_opts) do
    quote do
      def keyword_upload_factory(attrs) do
        name = attrs[:name] || En.dish()
        user = attrs[:user]
        status = attrs[:status] || :pending

        %KeywordUpload{
          name: name,
          user: user,
          status: status
        }
      end
    end
  end
end
