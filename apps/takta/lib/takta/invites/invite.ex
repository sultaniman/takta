defmodule Takta.Invites.Invite do
  use Takta.Model

  schema "invites" do
    field :used, :boolean, default: false
    field :code, :string
  end
end
