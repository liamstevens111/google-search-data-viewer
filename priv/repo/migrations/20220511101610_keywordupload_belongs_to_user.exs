defmodule GoogleSearchDataViewer.Repo.Migrations.KeywordUploadBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:keyword_uploads) do
      add :user_id, references(:users)
    end
  end
end
