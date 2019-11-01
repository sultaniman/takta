defmodule Takta.Invites.Invite do
  use Takta.Model
  alias Takta.Whiteboards.Whiteboard

  schema "invites" do
    field :used, :boolean, default: false
    field :code, :string

    belongs_to :whiteboard, Whiteboard
  end
end
