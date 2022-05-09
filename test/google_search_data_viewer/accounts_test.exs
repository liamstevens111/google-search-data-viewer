defmodule GoogleSearchDataViewer.AccountsTest do
  use GoogleSearchDataViewer.DataCase, async: true

  alias GoogleSearchDataViewer.Accounts
  alias GoogleSearchDataViewer.Accounts.User

  @valid_attrs %{email: "test@gmail.com", password: "aValidPasswordEntered"}
  @invalid_attrs %{email: "someemail", password: "somepassword"}

  describe "list_users/0" do
    test "returns all users" do
      user = insert(:user)

      assert Accounts.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "given a valid id, returns the existing user with the given id" do
      user = insert(:user)

      assert Accounts.get_user!(user.id) == user
    end

    test "given an invalid id, returns an error indicating it doesn't exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end
  end

  describe "get_user/1" do
    test "given an id, returns the existing user with the given id" do
      user = insert(:user)

      assert Accounts.get_user(user.id) == user
    end

    test "given an invalid id, returns nil indicating it doesn't exist" do
      assert Accounts.get_user(-1) == nil
    end
  end

  describe "validate_email_and_password/2" do
    test "given an email and password, validates correctly for existing email and password" do
      user = insert(:user, password: @valid_attrs[:password])

      assert Accounts.validate_email_and_password(user.email, @valid_attrs[:password]) ==
               {:ok, user}
    end

    test "given an incorrect email and password, fails to validate for existing password and email" do
      user = insert(:user)

      assert Accounts.validate_email_and_password(user.email, "wrongpassword") ==
               {:error, :unauthorized}
    end

    test "given a non-existant email and password, fails to validate and returns an error" do
      assert Accounts.validate_email_and_password("invalid@gmail.com", "wrongpassword") ==
               {:error, :not_found}
    end
  end

  describe "create_user/1" do
    test "with valid data, creates a user" do
      valid_attrs = %{email: "some@validemail.com", password: "somepassword"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some@validemail.com"
    end

    test "with invalid data, returns an error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
