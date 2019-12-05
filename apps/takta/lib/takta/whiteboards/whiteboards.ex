defmodule Takta.Whiteboards do
  @moduledoc false
  use Takta.Query
  alias Takta.Whiteboards.{Whiteboard, WhiteboardForms}
  alias Takta.Util.Changeset

  def all, do: Repo.all(Whiteboard)

  def find_by_id(wb_id) do
    Repo.one(from w in Whiteboard, where: w.id == ^wb_id)
  end

  def find_comments(wid) do
    wid
    |> preloaded(:comments)
    |> Map.get(:comments)
  end

  def find_annotations(wid) do
    wid
    |> preloaded(:annotations)
    |> Map.get(:annotations)
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

  defp preloaded(wid, field) do
    case find_by_id(wid) do
      nil -> {:error, :not_found}
      user -> Repo.preload(user, field)
    end
  end
end
