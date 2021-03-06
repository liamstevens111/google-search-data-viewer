defmodule GoogleSearchDataViewer.UserFactory do
  alias GoogleSearchDataViewer.Account.Schemas.User

  defmacro __using__(_opts) do
    quote do
      alias GoogleSearchDataViewer.Account.Passwords

      def user_factory(attrs) do
        email = attrs[:email] || Faker.Internet.email()
        password = attrs[:password] || Faker.String.base64(12)

        %User{
          email: email,
          hashed_password: Passwords.hash_password(password)
        }
      end
    end
  end
end
