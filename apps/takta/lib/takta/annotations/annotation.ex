defmodule Takta.Annotations.Annotation do
  @moduledoc false
  use Takta.Model
  alias Takta.Comments.Comment
  alias Takta.Whiteboards.Whiteboard

  schema "annotations" do
    # Point(x, y)
    field :coords, :map

    belongs_to :comment, Comment
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
