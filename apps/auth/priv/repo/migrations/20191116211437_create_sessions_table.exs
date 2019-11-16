defmodule Auth.Repo.Migrations.CreateSessionsTable do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :token, :text
      add :user_id, :uuid

      timestamps()
    end

    create index(:sessions, [:token])
    create index(:sessions, [:user_id])
  end
end
