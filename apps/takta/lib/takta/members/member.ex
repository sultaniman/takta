defmodule Takta.Members.Member do
  @moduledoc false
  use Takta.Model

  alias Takta.Accounts.User
  alias Takta.Whiteboards.Whiteboard

  schema "members" do
    field :can_annotate, :boolean, default: false
    field :can_comment, :boolean, default: false

    belongs_to :member, User
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
