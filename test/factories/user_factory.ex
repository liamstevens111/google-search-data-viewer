defmodule GoogleSearchDataViewer.UserFactory do
  alias GoogleSearchDataViewer.Accounts.User

  # Define your factories in /test/factories and declare it here,
  # eg: `use GoogleSearchDataViewer.Accounts.UserFactory`
  defmacro __using__(_opts) do
    quote do
      alias GoogleSearchDataViewer.Accounts.Passwords

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
