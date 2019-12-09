defmodule Auth.Permissions do
  @moduledoc false
  @doc """
  Check if user can update/delete whiteboard
  considering the following conditions

    1. User is active,
    2. User is admin or,
    3. User is the owner of a whiteboard
  """
  def can_manage_whiteboard(nil, _whiteboard), do: false
  def can_manage_whiteboard(_user, nil), do: false
  def can_manage_whiteboard(user, whiteboard) do
    user.is_active and (user.is_admin or user.id == whiteboard.owner_id)
  end
end
