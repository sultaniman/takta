defmodule Takta.Comments.CommentMapper do
  @moduledoc """
  Contains mappers for comment into different shapes.
  """
  alias Takta.Comments.Comment

  def to_json_basic(%Comment{} = comment) do
    %{
      id: comment.id,
      content: comment.content,
      author_id: comment.author_id,
      whiteboard_id: comment.whiteboard_id
    }
  end

  @doc """
  Comment author must be preloaded before
  using this mapper.
  TODO: preload author record
  """
  def to_json_extended(%Comment{} = comment) do
    User
    %{
      id: comment.id,
      content: comment.content,
      whiteboard_id: comment.whiteboard_id,
      author: %{
        author_id: comment.author_id
      }
    }
  end
end
