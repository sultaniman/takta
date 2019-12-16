defmodule Takta.Repo.Migrations.MakeMemberWhiteboardOptionalAsCollection do
  use Ecto.Migration

  def change do
    drop constraint(:members, "members_whiteboard_id_fkey")
    alter table(:members) do
      modify :whiteboard_id, references(:whiteboards, on_delete: :delete_all, type: :binary_id), null: true
    end
  end
end
