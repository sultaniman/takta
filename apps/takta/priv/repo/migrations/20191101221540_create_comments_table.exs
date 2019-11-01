defmodule Takta.Repo.Migrations.CreateCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :string
      add :code, :string

      add :author_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
