defmodule Takta.Comments.Comment do
  @moduledoc false
  use Takta.Model
  alias Takta.Accounts.User

  schema "comments" do
    field :content, :string

    belongs_to :author, User

    timestamps()
  end
end
