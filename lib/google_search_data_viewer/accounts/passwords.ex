defmodule GoogleSearchDataViewer.Accounts.Passwords do
  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def verify_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end
end
