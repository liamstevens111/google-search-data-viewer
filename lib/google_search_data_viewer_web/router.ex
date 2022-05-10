defmodule GoogleSearchDataViewerWeb.Router do
  use GoogleSearchDataViewerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GoogleSearchDataViewerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GoogleSearchDataViewerWeb.PutCurrentUserPlug
  end

  # coveralls-ignore-start
  pipeline :authorized do
    plug GoogleSearchDataViewerWeb.EnsureAuthenticatedPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  forward Application.get_env(:google_search_data_viewer, GoogleSearchDataViewerWeb.Endpoint)[
            :health_path
          ],
          GoogleSearchDataViewerWeb.HealthPlug

  scope "/", GoogleSearchDataViewerWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController, only: [:create, :new]
    resources "/sessions", SessionController, only: [:create, :new, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", GoogleSearchDataViewerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      # coveralls-ignore-start
      live_dashboard "/dashboard", metrics: GoogleSearchDataViewerWeb.Telemetry
      # coveralls-ignore-stop
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
