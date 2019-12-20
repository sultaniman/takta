defmodule Takta.InvitesTest do
  use Takta.{DataCase, Model, Query}
  alias Takta.{Accounts, Invites, Members, Whiteboards}

  describe "invites 💌 ::" do
    test "find all works as expected" do
      assert Invites.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Invites.all() |> List.first()
      assert Invites.find_by_id(one.id)
    end

    test "find_by_id returns nil if invite does not exist" do
      refute Invites.find_by_id(UUID.uuid4())
    end

    test "find_by_code works as expected" do
      one = Invites.all() |> List.first()
      assert Invites.find_by_code(one.code)
    end

    test "find_by_code returns nil if code not found" do
      refute Invites.find_by_id(UUID.uuid4())
    end

    test "find_for_user works as expected" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, member} = Members.create(%{
        can_annotate: true,
        can_comment: true,
        member_id: user.id,
        whiteboard_id: whiteboard.id
      })

      {:ok, _invite} = Invites.create(%{
        used: false,
        code: "test-code",
        created_by_id: user.id,
        member_id: member.id
      })

      user.id
      |> Invites.find_for_user()
      |> Enum.map(fn i ->
        assert Members.find_by_id(i.member_id)
      end)
    end

    test "can create new invite" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, member} = Members.create(%{
        can_annotate: true,
        can_comment: true,
        member_id: user.id,
        whiteboard_id: whiteboard.id
      })

      {:ok, invite} = Invites.create(%{
        used: false,
        code: "test-code",
        created_by_id: user.id,
        member_id: member.id
      })

      assert Invites.find_by_id(invite.id).id
    end

    test "can not create new invite if input is not valid" do
      {:error, changeset} = Invites.create(%{
        used: true
      })

      assert changeset.errors == [
        code: {"can't be blank", [validation: :required]},
        created_by_id: {"can't be blank", [validation: :required]},
        member_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update invite if input is valid" do
      invite = Invites.all() |> List.first()
      {:ok, updated} = Invites.update(invite, %{used: true})
      assert updated.used
    end

    test "can not update invite if input is not valid" do
      invite = Invites.all() |> List.first()
      assert {:error, changeset} = Invites.update(invite, %{member_id: nil})
      assert changeset.errors == [
        member_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can delete invite" do
      invite = Invites.all() |> List.first()
      assert {:ok, deleted} = Invites.delete(invite.id)
    end

    test "can not delete comment if comment does not exist" do
      assert {:error, :not_found} = Invites.delete(UUID.uuid4())
    end

    test "invite is valid only for 1h" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, member} = Members.create(%{
        can_annotate: true,
        can_comment: true,
        member_id: user.id,
        whiteboard_id: whiteboard.id
      })

      {:ok, invite} = Invites.create(%{
        code: "test-code",
        created_by_id: user.id,
        member_id: member.id
      })

      assert Invites.is_valid(invite.id)
    end

    test "invite is invalid after 1h" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, member} = Members.create(%{
        can_annotate: true,
        can_comment: true,
        member_id: user.id,
        whiteboard_id: whiteboard.id
      })

      {:ok, invite} = Invites.create(%{
        code: "test-code",
        created_by_id: user.id,
        member_id: member.id
      })

      invite
      |> change(%{inserted_at: Timex.shift(DateTime.utc_now(), hours: -2)})
      |> Repo.update()

      refute Invites.is_valid(invite.id)
    end

    test "inserted_at datetime is in UTC format" do
      invite = Invites.all() |> List.first()
      assert invite.inserted_at.time_zone == "Etc/UTC"
      assert invite.updated_at.time_zone == "Etc/UTC"
    end
  end
end
