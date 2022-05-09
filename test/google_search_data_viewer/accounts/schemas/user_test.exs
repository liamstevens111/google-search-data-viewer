defmodule GoogleSearchDataViewer.Accounts.Schemas.UserTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Accounts.Schemas.User

  describe "changeset/2" do
    test "given an empty changeset with empty fields, fails to validate" do
      user_changeset = User.changeset(%User{}, %{})

      refute user_changeset.valid?
    end

    test "given a changeset with email and password fields, validates" do
      user_changeset =
        User.changeset(%User{}, %{email: "testemail@email.com", password: "aValidPassword"})

      assert user_changeset.valid?
    end
  end

  describe "register_changeset/2" do
    test "given an invalid email format, shows validation error for email field" do
      user_changeset =
        User.register_changeset(%User{}, %{email: "testemail", password: "aValidPassword"})

      refute user_changeset.valid?

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(user_changeset)
    end

    test "given a pre-registered email, shows validation error for unique email constraint" do
      insert(:user, email: "duplicate@email.com", password: "aValidPassword")

      user_changeset =
        User.register_changeset(%User{}, %{email: "duplicate@email.com", password: "aValidPassword"})

      assert {:error, user_changeset} = Repo.insert(user_changeset)

      refute user_changeset.valid?

      assert %{email: ["has already been taken"]} = errors_on(user_changeset)
    end

    test "given a password length less than 12, shows validation error for password" do
      user_changeset =
        User.register_changeset(%User{}, %{email: "testemail@email.com", password: "ashortpass"})

      refute user_changeset.valid?

      assert %{password: ["should be at least 12 character(s)"]} = errors_on(user_changeset)
    end
  end
end
