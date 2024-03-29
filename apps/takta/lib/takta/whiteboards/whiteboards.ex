defmodule Takta.Whiteboards do
  @moduledoc false
  use Takta.Query
  alias Takta.Whiteboards.{Whiteboard, WhiteboardForms}

  def all, do: Repo.all(Whiteboard)

  def find_by_id(nil), do: nil
  def find_by_id(whiteboard_id) do
    Repo.one(from w in Whiteboard, where: w.id == ^whiteboard_id)
  end

  def find_for_user(user_id) do
    Repo.all(from w in Whiteboard, where: w.owner_id == ^user_id)
  end

  def with_members(whiteboard), do: whiteboard |> Repo.preload(:members)

  @doc """
  Preload comments
  """
  def with_comments(whiteboard), do: whiteboard |> Repo.preload(:comments)

  @doc """
  Preload annotations
  """
  def with_annotations(whiteboard), do: whiteboard |> Repo.preload(:annotations)

  def has_owner?(whiteboard_id, user_id) do
    case find_by_id(whiteboard_id) do
      nil -> false
      wb -> wb.owner_id == user_id
    end
  end

  def create(params) do
    %Whiteboard{}
    |> WhiteboardForms.new(params)
    |> Repo.insert()
  end

  def update(%Whiteboard{} = whiteboard, params) do
    whiteboard
    |> WhiteboardForms.update(params)
    |> Repo.update()
  end

  def delete(whiteboard_id) do
    case find_by_id(whiteboard_id) do
      nil -> {:error, :not_found}
      whiteboard -> Repo.delete(whiteboard)
    end
  end
end
