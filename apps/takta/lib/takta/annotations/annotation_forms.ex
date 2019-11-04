defmodule Takta.Annotations.AnnotationForms do
  use Takta.{Model, Query}

  alias Takta.Annotations.Annotation

  def base(%Annotation{} = annotation, attrs) do
    fields = [:coords, :comment_id, :whiteboard_id]

    annotation
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:comment_id)
    |> foreign_key_constraint(:whiteboard_id)
  end

  def new(%Annotation{} = annotation, params), do: annotation |> base(params)
  def update(%Annotation{} = annotation, params), do: annotation |> base(params)
end
