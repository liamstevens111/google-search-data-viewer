defmodule GoogleSearchDataViewer.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoogleSearchDataViewer.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@gmail.com",
        password: "aValidPasswordEntered"
      })
      |> GoogleSearchDataViewer.Accounts.create_user()

    user
  end
end
