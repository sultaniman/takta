defmodule TaktaWeb.WhiteboardView do
  @moduledoc false
  use TaktaWeb, :view
  alias Takta.Whiteboards.Whiteboard

  def render("whiteboard.json", %Whiteboard{} = whiteboard) do
    %{
      id: whiteboard.id,
      name: whiteboard.name,
      path: whiteboard.path
    }
  end
end
