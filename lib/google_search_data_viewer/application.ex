defmodule GoogleSearchDataViewer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GoogleSearchDataViewer.Repo,
      # Start the Telemetry supervisor
      GoogleSearchDataViewerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GoogleSearchDataViewer.PubSub},
      # Start the Endpoint (http/https)
      GoogleSearchDataViewerWeb.Endpoint,
      {Oban, oban_config()}
      # Start a worker by calling: GoogleSearchDataViewer.Worker.start_link(arg)
      # {GoogleSearchDataViewer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoogleSearchDataViewer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GoogleSearchDataViewerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:google_search_data_viewer, Oban)
  end
end
