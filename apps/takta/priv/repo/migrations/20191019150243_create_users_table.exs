defmodule Takta.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :avatar, :string
      add :full_name, :string
      add :password_hash, :string
      add :is_active, :boolean, default: false, null: false
      add :is_admin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create index(:users, [:full_name])
  end
end
