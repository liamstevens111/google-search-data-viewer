defmodule GoogleSearchDataViewer.Repo.Migrations.CreateKeywordUploads do
  use Ecto.Migration

  def change do
    create table(:keyword_uploads) do
      add :name, :string, null: false
      add :html, :text
      add :status, :string, null: false

      timestamps()
    end

    create index(:keyword_uploads, [:name])
  end
end
