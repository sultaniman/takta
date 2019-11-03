defmodule Takta.Annotations.Annotation do
  @moduledoc false
  use Takta.Model
  alias Takta.Comments.Comment

  schema "annotations" do
    # Point(x, y)
    field :coords, :map

    belongs_to :comment, Comment

    timestamps()
  end
end
