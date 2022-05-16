defmodule GoogleSearchDataViewer.Repo.Migrations.CreateKeywordUploads do
  use Ecto.Migration

  def change do
    create table(:keyword_uploads) do
      add :name, :string
      add :html, :text
      add :status, :string

      timestamps()
    end

    create index(:keyword_uploads, [:name])
  end
end
