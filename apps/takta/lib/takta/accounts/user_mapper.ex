defmodule Takta.Accounts.UserMapper do
  @moduledoc false
  alias Takta.Accounts.User

  def to_json_basic(%User{} = user) do
    %{
      id: user.id,
      avatar: user.avatar,
      full_name: user.full_name,
      is_active: user.is_active,
      is_admin: user.is_admin
    }
  end
end
