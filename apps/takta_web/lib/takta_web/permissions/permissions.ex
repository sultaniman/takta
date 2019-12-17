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
  Check if user can comment on whiteboard
  considering the following conditions

    1. User is admin or,
    2. User has membership to comment,
    3. User is the owner of related whiteboard.
  """
  def can_comment(nil, _whiteboard), do: false
  def can_comment(_user, nil), do: false
  def can_comment(user, whiteboard) do
    case Members.find_member(user.id, whiteboard.id) do
      nil -> user.is_admin or whiteboard.owner_id == user.id
      member -> member.can_comment
    end
  end

  @doc """
  Check if user can see comment
  considering the following conditions

    1. User is admin or,
    2. User is the author of comment,
    3. User has membership to see discussions,
    4. User is the owner of related whiteboard.
  """
  def can_see_comment(nil, _comment), do: false
  def can_see_comment(_user, nil), do: false
  def can_see_comment(user, comment) do
    is_whiteboard_owner = Whiteboards.has_owner?(comment.whiteboard_id, user.id)
    can_see = is_whiteboard_owner or user.is_admin or user.id == comment.author_id
    has_membership = Members.whiteboard_has_member?(comment.whiteboard_id, user.id)
    has_membership or (user.is_active and can_see)
  end

  @doc """
  Check if user can update
  considering the following conditions

    1. User is admin or,
    2. User is the author of comment.
  """
  def can_manage_comment(nil, _comment), do: false
  def can_manage_comment(_user, nil), do: false
  def can_manage_comment(user, comment) do
    user.is_active and (user.is_admin or user.id == comment.author_id)
  end

  @doc """
  Check if user can manage
  considering the following conditions

    1. User is admin or,
    2. User is the owner of collection.
  """
  def can_manage_collection?(nil, _collection), do: false
  def can_manage_collection?(_user, nil), do: false
  def can_manage_collection?(user, collection) do
    user.is_active and (user.is_admin or user.id == collection.owner_id)
  end
end
