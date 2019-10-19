defmodule Takta.Whiteboards.Whiteboard do
  @moduledoc false
  use Takta.Model

  alias Takta.Accounts.User
  alias Takta.Members.Member

  # Boards are whiteboard
  # which is just an image
  schema "whiteboards" do
    field :name, :string
    field :path, :string

    belongs_to :owner, User
    has_many :members, Member

    timestamps()
  end
end
