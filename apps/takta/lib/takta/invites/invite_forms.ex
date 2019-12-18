defmodule Takta.Invites.InviteForms do
  use Takta.{Model, Query}

  alias Takta.Invites.Invite

  def base(%Invite{} = invite, attrs) do
    fields = [
      :used,
      :code,
      :created_by_id,
      :member_id
    ]

    required_fields = [:code, :created_by_id, :member_id]

    invite
    |> cast(attrs, fields)
    |> validate_required(required_fields)
    |> foreign_key_constraint(:created_by_id)
    |> foreign_key_constraint(:member_id)
  end

  def new(%Invite{} = invite, params), do: invite |> base(params)
  def update(%Invite{} = invite, params), do: invite |> base(params)
end
