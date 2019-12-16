defmodule Takta.Repo.Migrations.CreateCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
