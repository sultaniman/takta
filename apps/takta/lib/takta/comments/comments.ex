defmodule Takta.Comments do
  @moduledoc false
  use Takta.Query
  alias Takta.Comments.{Comment, CommentForms}

  def all, do: Repo.all(Comment)

  def find_by_id(comment_id) do
    Repo.one(from c in Comment, where: c.id == ^comment_id)
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

  def delete(comment_id) do
    case find_by_id(comment_id) do
      nil -> {:error, :not_found}
      comment -> comment |> Repo.delete()
    end
  end

  def with_author(comment), do: comment |> Repo.preload(:author)
end
