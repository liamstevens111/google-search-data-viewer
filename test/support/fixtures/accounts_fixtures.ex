defmodule GoogleSearchDataViewer.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoogleSearchDataViewer.Accounts` context.
  """

  @doc """
  Generate a user.
  """

  @valid_email "test@gmail.com"
  @valid_password "aValidPasswordEntered"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: @valid_email,
        password: @valid_password
      })
      |> GoogleSearchDataViewer.Accounts.create_user()

    user
  end
end
