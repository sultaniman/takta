defmodule Takta.Comments.CommentMapper do
  @moduledoc """
  Contains mappers for comment into different shapes.
  """
  alias Takta.Accounts.UserMapper
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
  Comment author must be preloaded
  before using this mapper.
  """
  def to_json_extended(%Comment{} = comment) do
    %{
      id: comment.id,
      content: comment.content,
      whiteboard_id: comment.whiteboard_id,
      author_id: comment.author_id,
      author: UserMapper.to_json_basic(comment.author)
    }
  end
end
