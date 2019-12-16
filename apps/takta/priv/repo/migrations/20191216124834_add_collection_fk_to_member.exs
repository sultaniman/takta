defmodule Takta.Repo.Migrations.AddCollectionFkToMember do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :collection_id, references(:collections, on_delete: :delete_all, type: :binary_id), null: true
    end
  end
end
