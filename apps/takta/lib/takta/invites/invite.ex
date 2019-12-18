defmodule Takta.Invites.Invite do
  @moduledoc false
  use Takta.Model
  alias Takta.Accounts.User
  alias Takta.Members.Member

  schema "invites" do
    field :used, :boolean, default: false
    field :code, :string

    # Invite by user is always the owner of
    # whiteboard or collection
    belongs_to :created_by, User
    belongs_to :member, Member

    timestamps()
  end
end
