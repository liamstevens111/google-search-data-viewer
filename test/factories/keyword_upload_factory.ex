defmodule GoogleSearchDataViewer.KeywordUploadFactory do
  alias Faker.Food.En
  alias GoogleSearchDataViewer.Keyword.Schemas.KeywordUpload

  defmacro __using__(_opts) do
    quote do
      def keyword_upload_factory do
        %KeywordUpload{
          name: En.dish(),
          status: :pending,
          user: build(:user)
        }
      end
    end
  end
end
