defmodule GoogleSearchDataViewer.Factory do
  use ExMachina.Ecto, repo: GoogleSearchDataViewer.Repo
  alias GoogleSearchDataViewer.Accounts.User

  # Define your factories in /test/factories and declare it here,
  # eg: `use GoogleSearchDataViewer.Accounts.UserFactory`
  def user_factory do
    %User{
      email: Faker.Internet.email(),
      password: Faker.String.base64(12)
    }
  end
end
