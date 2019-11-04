defmodule Takta.Comments.Comment do
  @moduledoc false
  use Takta.Model
  alias Takta.Accounts.User
  alias Takta.Whiteboards.Whiteboard

  schema "comments" do
    field :content, :string

    belongs_to :author, User
    belongs_to :whiteboard, Whiteboard

    timestamps()
  end
end
