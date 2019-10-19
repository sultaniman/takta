defmodule Takta.Repo.Migrations.CreateMembersTable do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :can_annotate, :boolean, default: false, null: false
      add :can_comment, :boolean, default: false, null: false
      add :member_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :whiteboard_id, references(:whiteboards, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
