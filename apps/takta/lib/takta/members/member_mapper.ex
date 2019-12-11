defmodule Takta.Members.MemberMapper do
  @moduledoc false
  alias Takta.Members.Member
  alias Takta.Accounts.UserMapper
  alias Takta.Whiteboards.WhiteboardMapper

  def to_json_basic(%Member{} = member) do
    %{
      id: member.id,
      member_id: member.member_id,
      whiteboard_id: member.whiteboard_id
    }
  end

  def to_json_extended(%Member{} = member) do
    %{
      id: member.id,
      can_annotate: member.can_annotate,
      can_comment: member.can_annotate,

      member_id: member.member_id,
      whiteboard_id: member.whiteboard_id,

      member: UserMapper.to_json_basic(member.member),
      whiteboard: WhiteboardMapper.to_json_basic(member.whiteboard)
    }
  end
end
