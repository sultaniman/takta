defmodule Takta.Members.MemberForms do
  @moduledoc false
  use Takta.{Model, Query}

  alias Takta.Members.Member

  def base(%Member{} = member, attrs) do
    fields = [:can_annotate, :can_comment, :member_id, :whiteboard_id]
    required_fields = [:member_id, :whiteboard_id]

    member
    |> cast(attrs, fields)
    |> validate_required(required_fields)
    |> foreign_key_constraint(:member_id)
    |> foreign_key_constraint(:whiteboard_id)
  end

  def new(%Member{} = member, params), do: member |> base(params)
  def update(%Member{} = member, params), do: member |> base(params)
end
