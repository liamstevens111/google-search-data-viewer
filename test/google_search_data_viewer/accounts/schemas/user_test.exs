defmodule GoogleSearchDataViewer.Accounts.Schemas.UserTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Accounts.Schemas.User

  describe "changeset/2" do
    test "given an empty changeset with empty fields, fails to validate" do
      user_changeset = User.changeset(%User{}, %{})

      assert user_changeset.valid? == false
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

      assert user_changeset.valid? == false

      assert errors_on(user_changeset) == %{email: ["must have the @ sign and no spaces"]}
    end

    test "given a pre-registered email, shows validation error for unique email constraint" do
      insert(:user, email: "duplicate@email.com", password: "aValidPassword")

      user_changeset =
        User.register_changeset(%User{}, %{email: "duplicate@email.com", password: "aValidPassword"})

      assert {:error, user_changeset} = Repo.insert(user_changeset)

      assert user_changeset.valid? == false

      assert errors_on(user_changeset) == %{email: ["has already been taken"]}
    end

    test "given a password length less than 12, shows validation error for password" do
      user_changeset =
        User.register_changeset(%User{}, %{email: "testemail@email.com", password: "ashortpass"})

      assert user_changeset.valid? == false

      assert errors_on(user_changeset) == %{password: ["should be at least 12 character(s)"]}
    end
  end
end
