defmodule GoogleSearchDataViewer.Repo do
  use Ecto.Repo,
    otp_app: :google_search_data_viewer,
    adapter: Ecto.Adapters.Postgres
end
