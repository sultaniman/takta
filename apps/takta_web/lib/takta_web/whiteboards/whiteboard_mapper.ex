defmodule TaktaWeb.Whiteboards.WhiteboardMapper do
  @moduledoc """
  Contains mappers for whiteboard into different shapes.
  """
  alias Takta.Whiteboards.Whiteboard

  def to_json_basic(%Whiteboard{} = whiteboard) do
    %{
      id: whiteboard.id,
      name: whiteboard.name,
      path: whiteboard.path
    }
  end
end
