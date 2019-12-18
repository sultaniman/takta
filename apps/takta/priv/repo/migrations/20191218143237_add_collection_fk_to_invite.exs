defmodule Takta.Repo.Migrations.AddCollectionFkToInvite do
  use Ecto.Migration

  def change do
    # Since we have collections
    # both fields have to be nullable
    # and validation should take over
    # when both are empty.
    drop constraint(:invites, "invites_whiteboard_id_fkey")
    alter table(:invites) do
      add :collection_id, references(:collections, on_delete: :delete_all, type: :binary_id), null: true
      modify :whiteboard_id, references(:whiteboards, on_delete: :delete_all, type: :binary_id), null: true
    end
  end
end
