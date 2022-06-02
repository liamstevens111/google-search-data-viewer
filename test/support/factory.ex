defmodule GoogleSearchDataViewer.Factory do
  use ExMachina.Ecto, repo: GoogleSearchDataViewer.Repo
  use GoogleSearchDataViewer.KeywordUploadFactory
  use GoogleSearchDataViewer.SearchResultUrlFactory
  use GoogleSearchDataViewer.UserFactory
end
