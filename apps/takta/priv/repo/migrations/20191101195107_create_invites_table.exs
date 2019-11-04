defmodule Takta.Repo.Migrations.CreateInvitesTable do
  use Ecto.Migration

  def change do
    create table(:invites, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :used, :boolean, default: false
      add :code, :string

      add :used_by_id, references(:users, on_delete: :delete_all, type: :binary_id), null: true
      add :created_by_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :whiteboard_id, references(:whiteboards, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
