defmodule Takta.Whiteboards.Whiteboard do
  @moduledoc false
  use Takta.Model

  alias Takta.Accounts.User
  alias Takta.Annotations.Annotation
  alias Takta.Comments.Comment
  alias Takta.Collections.Collection
  alias Takta.Members.Member

  # Boards are whiteboard
  # which is just an image
  schema "whiteboards" do
    field :name, :string
    field :path, :string

    belongs_to :owner, User
    belongs_to :collection, Collection

    has_many :members, Member
    has_many :comments, Comment
    has_many :annotations, Annotation

    timestamps()
  end
end
