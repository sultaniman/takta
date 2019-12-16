defmodule Takta.Collections.Collection do
  @moduledoc false
  use Takta.Model
  alias Takta.Accounts.User
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Members.Member

  schema "collections" do
    field :name, :string

    belongs_to :owner, User
    has_many :whiteboards, Whiteboard
    has_many :members, Member, foreign_key: :member_id

    timestamps()
  end
end
