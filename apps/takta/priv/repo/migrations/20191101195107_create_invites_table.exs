defmodule Takta.Repo.Migrations.CreateInvitesTable do
  use Ecto.Migration

  def change do
    create table(:invites, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :used, :boolean, default: false
      add :code, :text

      add :created_by_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :member_id, references(:members, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
