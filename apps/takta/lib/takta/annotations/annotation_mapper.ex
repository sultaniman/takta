defmodule Takta.Accounts.AnnotationMapper do
  @moduledoc false
  alias Takta.Annotations.Annotation

  def to_json_basic(%Annotation{} = annotation) do
    %{
      id: annotation.id,
      coords: annotation.coords,
      comment_id: annotation.comment_id,
      whiteboard_id: annotation.whiteboard_id
    }
  end
end
