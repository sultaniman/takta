defmodule Takta.Repo.Migrations.CreateAnnotationsTable do
  use Ecto.Migration

  def change do
    create table(:annotations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :coords, :map

      add :comment_id, references(:comments, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
