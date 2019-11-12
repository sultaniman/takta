defmodule Takta.MembersTest do
  use Takta.{DataCase, Query}
  alias Takta.{
    Accounts,
    Members,
    Whiteboards
  }

  describe "members 🎭 ::" do
    test "find all works as expected" do
      assert Members.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Members.all() |> List.first()
      assert Members.find_by_id(one.id)
    end

    test "find_by_id returns nil if member not found" do
      refute Members.find_by_id(UUID.uuid4())
    end

    test "can create new member" do
      wb = Whiteboards.all() |> List.first()
      user = Accounts.all() |> List.first()

      {:ok, member} = Members.create(%{
        can_annotate: false,
        member_id: user.id,
        whiteboard_id: wb.id
      })

      saved_member = Members.find_by_id(member.id)
      refute saved_member.can_annotate
      assert saved_member.member_id == user.id
      assert saved_member.whiteboard_id == wb.id
    end

    test "can not create new member if input is not valid" do
      {:error, changeset} = Members.create(%{})

      assert changeset.errors
      assert changeset.errors == [
        member_id: {"can't be blank", [validation: :required]},
        whiteboard_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update member if input is valid" do
      member = Members.all() |> List.first()
      {:ok, updated} = Members.update(member, %{can_comment: false})
      refute updated.can_comment
    end

    test "can not update member if input is not valid" do
      member = Members.all() |> List.first()

      assert {:error, changeset} = Members.update(member, %{member_id: nil})
      assert changeset.errors
      assert changeset.errors == [
        member_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can delete comment" do
      member = Members.all() |> List.first()
      assert {:ok, deleted} = Members.delete(member.id)
      assert deleted.id == member.id
    end

    test "can not delete member if comment does not exist" do
      assert {:error, :not_found} = Members.delete(UUID.uuid4())
    end
  end
end
