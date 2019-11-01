defmodule Takta.Repo.Migrations.CreateWhiteBoardsTable do
  use Ecto.Migration

  def change do
    create table(:whiteboards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :path, :string

      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
