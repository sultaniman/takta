defmodule Takta.Whiteboards do
  @moduledoc false
  use Takta.Query
  alias Takta.Whiteboards.{Whiteboard, WhiteboardForms}

  def all, do: Repo.all(Whiteboard)

  def find_by_id(wb_id) do
    Repo.one(from w in Whiteboard, where: w.id == ^wb_id)
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
end
