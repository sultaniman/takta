defmodule Takta.Invites.Invite do
  @moduledoc false
  use Takta.Model
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Accounts.User

  schema "invites" do
    field :used, :boolean, default: false
    field :code, :string

    belongs_to :used_by, User
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
