defmodule GoogleSearchDataViewer.Factory do
  use ExMachina.Ecto, repo: GoogleSearchDataViewer.Repo

  # Define your factories in /test/factories and declare it here,
  use GoogleSearchDataViewer.UserFactory
end
