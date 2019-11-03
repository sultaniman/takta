defmodule Takta.Whiteboards.WhiteboardForms do
  use Takta.{Model, Query}

  alias Takta.Whiteboards.Whiteboard

  def base(%Whiteboard{} = wb, attrs) do
    fields = [:name, :path, :owner_id]
    required_fields = [:path, :owner_id]

    wb
    |> cast(attrs, fields)
    |> validate_required(required_fields)
  end

  def new(%Whiteboard{} = wb, params), do: wb |> base(params)
  def update(%Whiteboard{} = wb, params), do: wb |> base(params)
end
