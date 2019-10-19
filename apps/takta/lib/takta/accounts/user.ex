defmodule Takta.Accounts.User do
  @moduledoc false
  use Takta.Model

  alias Takta.Whiteboards.Whiteboard
  alias Takta.Members.Member

  schema "users" do
    field :email, :string
    field :avatar, :string
    field :full_name, :string

    field :is_active, :boolean
    field :is_admin, :boolean, default: false

    field :password_hash, :string
    field :password, :string, virtual: true

    # Used to change password
    field :new_password, :string, virtual: true
    field :new_password_confirmation, :string, virtual: true

    has_many :whiteboards, Whiteboard, foreign_key: :owner_id
    has_many :memberships, Member, foreign_key: :member_id

    timestamps()
  end
end
