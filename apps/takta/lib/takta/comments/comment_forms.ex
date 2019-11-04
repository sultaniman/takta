defmodule Takta.Comments.CommentForms do
  use Takta.{Model, Query}

  alias Takta.Comments.Comment

  def base(%Comment{} = comment, attrs) do
    fields = [:content, :author_id, :whiteboard_id]

    comment
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_length(:content, min: 3)
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:whiteboard_id)
  end

  def new(%Comment{} = comment, params), do: comment |> base(params)
  def update(%Comment{} = comment, params), do: comment |> base(params)
end
