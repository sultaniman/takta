defmodule TaktaWeb.Permissions do
  @moduledoc false
  alias Takta.{Members, Whiteboards}

  @doc """
  Check if user can update/delete whiteboard
  considering the following conditions

    1. User is active,
    2. User is admin or,
    3. User is the owner of whiteboard.
  """
  def can_manage_whiteboard(nil, _whiteboard), do: false
  def can_manage_whiteboard(_user, nil), do: false
  def can_manage_whiteboard(user, whiteboard) do
    user.is_active and (user.is_admin or user.id == whiteboard.owner_id)
  end

  @doc """
  Check if user can see comment
  considering the following conditions

    1. User is active,
    2. User is admin or,
    3. User is the author of comment,
    4. User has membership to see discussions,
    5. User is the owner of related whiteboard.
  """
  def can_see_comment(nil, _comment), do: false
  def can_see_comment(_user, nil), do: false
  def can_see_comment(user, comment) do
    is_owner = Whiteboards.has_owner?(comment.whiteboard_id, user.id)
    can_see = user.is_active and (is_owner or user.is_admin or user.id == comment.author_id)
    has_membership = Members.whiteboard_has_member?(comment.whiteboard_id, user.id)
    can_see or has_membership
  end
end
