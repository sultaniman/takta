defmodule Takta.Validators.MemberValidator do
  @moduledoc false
  import Ecto.Changeset, only: [add_error: 3, get_field: 3]

  @doc """
  Check if collection or whiteboard ids set
  """
  def has_collection_or_whiteboard(%Ecto.Changeset{} = changeset) do
    if all_empty?(changeset, [:collection_id, :whiteboard_id]) do
      changeset
      |> add_error(:whiteboard_id, "set whiteboard or collection")
    else
      changeset
    end
  end

  defp all_empty?(changeset, fields) do
    fields
    |> Enum.map(fn key -> get_field(changeset, key, nil) end)
    |> Enum.reject(& &1 == nil)
    |> Enum.empty?()
  end
end
