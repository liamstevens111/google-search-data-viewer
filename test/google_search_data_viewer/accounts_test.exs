defmodule GoogleSearchDataViewer.AccountsTest do
  use GoogleSearchDataViewer.DataCase

  alias GoogleSearchDataViewer.Accounts

  describe "users" do
    alias GoogleSearchDataViewer.Accounts.User

    import GoogleSearchDataViewer.AccountsFixtures

    @invalid_attrs %{email: "someemail", password: "somepassword"}
    @valid_email "test@gmail.com"
    @valid_password "aValidPasswordEntered"

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      assert Accounts.get_user_by_email(user.email) == user
    end

    test "validate_email_and_password/2 validates correctly for matching password for email" do
      user = user_fixture()
      assert Accounts.validate_email_and_password(@valid_email, @valid_password) == {:ok, user}
    end

    test "validate_email_and_password/2 fails for incorrect password and email" do
      user = user_fixture()

      assert Accounts.validate_email_and_password(user.email, "wrongpassword") ==
               {:error, :unauthorized}
    end

    test "validate_email_and_password/2 fails for non-existant user" do
      assert Accounts.validate_email_and_password("invalid@gmail.com", "wrongpassword") ==
               {:error, :not_found}
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some@validemail.com", password: "somepassword"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some@validemail.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
