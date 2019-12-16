defmodule Takta.Repo.Migrations.AddCollectionFkToWhiteboards do
  use Ecto.Migration

  def change do
    alter table(:whiteboards) do
      add :collection_id, references(:collections, on_delete: :delete_all, type: :binary_id), null: true
    end
  end
end
