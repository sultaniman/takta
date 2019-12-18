defmodule Takta.Invites.InviteMapper do
  @moduledoc false
  alias Takta.Invites.Invite
  alias Takta.Accounts.UserMapper
  alias Takta.Members.MemberMapper
  alias Takta.Whiteboards.WhiteboardMapper

  def to_json_basic(%Invite{} = invite) do
    %{
      id: invite.id,
      used: invite.used,
      code: invite.code,
      created_by_id: invite.created_by_id,
      member_id: invite.member_id
    }
  end

  def to_json_extended(%Invite{} = invite) do
    %{
      id: invite.id,
      used: invite.used,
      code: invite.code,
      created_by: UserMapper.to_json_basic(invite.created_by),
      member: MemberMapper.to_json_basic(invite.member)
    }
  end
end
