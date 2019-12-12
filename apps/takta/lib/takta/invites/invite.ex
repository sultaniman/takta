defmodule Takta.Invites.Invite do
  @moduledoc false
  use Takta.Model
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Accounts.User

  schema "invites" do
    field :used, :boolean, default: false
    field :code, :string

    # Once user accepts invite, membership
    # with permissions should be created.
    field :can_annotate, :boolean, default: false
    field :can_comment, :boolean, default: false

    # Invite by user (owner of white board)
    # to `used_by` future user which will be
    # created upon registration of a new user
    # or be assigned to an existing user
    belongs_to :used_by, User
    belongs_to :created_by, User
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
