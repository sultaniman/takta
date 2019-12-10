defmodule Takta.Whiteboards do
  @moduledoc false
  use Takta.Query
  alias Takta.Whiteboards.{Whiteboard, WhiteboardForms}
  alias Takta.Util.Changeset

  def all, do: Repo.all(Whiteboard)

  def find_by_id(wid) do
    Repo.one(from w in Whiteboard, where: w.id == ^wid)
  end

  def find_by_id!(wid) do
    Repo.get!(Whiteboard, wid)
  end

  def find_for_user(user_id) do
    Repo.all(from w in Whiteboard, where: w.owner_id == ^user_id)
  end

  def with_comments(wb) do
    wb
    |> Repo.preload(:comments)
  end

  def with_annotations(wb) do
    wb
    |> Repo.preload(:annotations)
  end

  def has_owner(wid, user_id) do
    case find_by_id(wid) do
      nil -> false
      wb -> wb.owner_id == user_id
    end
  end

  def create(params) do
    %Whiteboard{}
    |> WhiteboardForms.new(params)
    |> Repo.insert()
  end

  def update(%Whiteboard{} = wb, params) do
    wb
    |> WhiteboardForms.update(params)
    |> Repo.update()
  end

  def delete(wid) do
    wid
    |> find_by_id()
    |> Changeset.delete()
  end
end
