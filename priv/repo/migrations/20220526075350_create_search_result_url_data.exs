defmodule GoogleSearchDataViewer.Repo.Migrations.CreateSearchResultUrlData do
  use Ecto.Migration

  def change do
    create table(:search_result_url_data) do
      add :url, :string
      add :is_adword, :boolean, default: false, null: false
      add :is_top_adword, :boolean, default: false, null: false

      add :keyword_upload_id, references(:keyword_uploads, on_delete: :delete_all)

      timestamps()
    end

    create index(:search_result_url_data, [:keyword_upload_id])
    create index(:search_result_url_data, [:url])
  end
end
