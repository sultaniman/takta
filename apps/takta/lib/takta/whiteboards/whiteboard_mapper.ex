defmodule Takta.Whiteboards.WhiteboardMapper do
  @moduledoc """
  Contains mappers for whiteboard into different shapes.
  """
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Accounts.AnnotationMapper
  alias Takta.Comments.CommentMapper

  def to_json_basic(%Whiteboard{} = whiteboard) do
    %{
      id: whiteboard.id,
      name: whiteboard.name,
      path: whiteboard.path
    }
  end

  def to_json_extended(%Whiteboard{} = whiteboard) do
    comments =
      whiteboard.comments
      |> Enum.map(&CommentMapper.to_json_basic/1)

    annotations =
      whiteboard.annotations
      |> Enum.map(&AnnotationMapper.to_json_basic/1)

    %{
      id: whiteboard.id,
      name: whiteboard.name,
      path: whiteboard.path,
      comments: comments,
      annotations: annotations
    }
  end
end
