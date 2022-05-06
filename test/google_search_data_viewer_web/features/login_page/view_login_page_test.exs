defmodule GoogleSearchDataViewerWeb.LoginPage.ViewLoginPage do
  use GoogleSearchDataViewerWeb.FeatureCase

  import Wallaby.Query, only: [css: 2, text_field: 1, button: 1]

  @email_field text_field("Email")
  @password_field text_field("Password")
  @save_button button("Sign in")

  @login_route Routes.session_path(GoogleSearchDataViewerWeb.Endpoint, :new)

  feature "view login page", %{session: session} do
    session
    |> visit(@login_route)
    |> assert_has(Query.text("Sign in to your account"))
  end

  feature "log into a page", %{session: session} do
    password = "passwordpassword"

    user = insert(:user, password: password)

    session
    |> visit(@login_route)
    |> fill_in(@email_field, with: user.email)
    |> fill_in(@password_field, with: password)
    |> click(@save_button)
    |> assert_has(css(".alert", text: "Welcome, you have signed in!"))
  end
end
