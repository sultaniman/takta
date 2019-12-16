defmodule Takta.Members.Member do
  @moduledoc false
  use Takta.Model

  alias Takta.Accounts.User
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Collections.Collection

  schema "members" do
    field :can_annotate, :boolean, default: true
    field :can_comment, :boolean, default: true

    belongs_to :member, User
    belongs_to :collection, Collection
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
