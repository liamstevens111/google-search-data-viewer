defmodule GoogleSearchDataViewer.Factory do
  use ExMachina.Ecto, repo: GoogleSearchDataViewer.Repo
  use GoogleSearchDataViewer.UserFactory
  use GoogleSearchDataViewer.KeywordUploadFactory
end
