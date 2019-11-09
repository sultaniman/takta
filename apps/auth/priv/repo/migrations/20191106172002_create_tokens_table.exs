defmodule Auth.Repo.Migrations.CreateTokensTable do
  use Ecto.Migration

  def change do
    create table(:magic_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :token, :text
      add :user_id, :uuid

      timestamps()
    end

    create index(:magic_tokens, [:token])
    create index(:magic_tokens, [:user_id])
  end
end
