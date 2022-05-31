defmodule GoogleSearchDataViewer.Factory do
  use ExMachina.Ecto, repo: GoogleSearchDataViewer.Repo
  use GoogleSearchDataViewer.KeywordUploadFactory
  use GoogleSearchDataViewer.SearchResultUrlDataFactory
  use GoogleSearchDataViewer.UserFactory
end
