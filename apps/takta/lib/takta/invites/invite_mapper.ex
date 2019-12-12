defmodule Takta.Invites.InviteMapper do
  @moduledoc false
  alias Takta.Invites.Invite
  alias Takta.Accounts.UserMapper
  alias Takta.Whiteboards.WhiteboardMapper

  def to_json_basic(%Invite{} = invite) do
    %{
      id: invite.id,
      used: invite.used,
      code: invite.code,
      created_by_id: invite.created_by_id,
      used_by_id: invite.used_by_id,
      whiteboard_id: invite.whiteboard_id
    }
  end

  def to_json_extended(%Invite{} = invite) do
    %{
      id: invite.id,
      used: invite.used,
      code: invite.code,
      created_by: UserMapper.to_json_basic(invite.created_by),
      used_by: UserMapper.to_json_basic(invite.used_by),
      whiteboard: WhiteboardMapper.to_json_basic(invite.whiteboard)
    }
  end
end
