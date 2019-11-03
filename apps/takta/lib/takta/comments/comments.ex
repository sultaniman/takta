defmodule Takta.Comments do
  @moduledoc false
  use Takta.Query
  alias Takta.Comments.{Comment, CommentForms}

  def all, do: Repo.all(Comment)

  def find_by_id(cid) do
    Repo.one(from c in Comment, where: c.id == ^cid)
  end

  def create(params) do
    %Comment{}
    |> CommentForms.new(params)
    |> Repo.insert()
  end

  def update(%Comment{} = comment, params) do
    comment
    |> CommentForms.update(params)
    |> Repo.update()
  end

  def delete(cid) do
    case find_by_id(cid) do
      nil -> {:error, :not_found}
      comment -> comment |> Repo.delete()
    end
  end
end
