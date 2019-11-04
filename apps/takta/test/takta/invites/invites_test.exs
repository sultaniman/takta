defmodule Takta.InvitesTest do
  use Takta.{DataCase, Model, Query}
  alias Takta.{Accounts, Invites, Whiteboards}

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

    test "can create new invite" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, invite} = Invites.create(%{
        content: "test-invite",
        code: "test-code",
        created_by_id: user.id,
        whiteboard_id: whiteboard.id
      })

      assert Invites.find_by_id(invite.id).id
    end

    test "can not create new invite if input is not valid" do
      {:error, changeset} = Invites.create(%{
        content: "test-invite",
      })

      assert changeset.errors
      assert changeset.errors == [
        code: {"can't be blank", [validation: :required]},
        created_by_id: {"can't be blank", [validation: :required]},
        whiteboard_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update invite if input is valid" do
      invite = Invites.all() |> List.first()
      user = Accounts.find_by_email("consultant1@example.com")
      {:ok, updated} = Invites.update(invite, %{used_by_id: user.id})
      assert updated.used_by_id == user.id
    end

    test "can not update invite if input is not valid" do
      invite = Invites.all() |> List.first()
      {:error, changeset} = Invites.update(invite, %{whiteboard_id: nil})

      assert changeset.errors
      assert changeset.errors == [
        whiteboard_id: {"can't be blank", [validation: :required]}
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

      {:ok, invite} = Invites.create(%{
        content: "test-invite",
        code: "test-code",
        created_by_id: user.id,
        whiteboard_id: whiteboard.id
      })

      assert Invites.is_valid(invite.id)
    end

    test "invite is invalid after 1h" do
      user = Accounts.all() |> List.first()
      whiteboard = Whiteboards.all() |> List.first()

      {:ok, invite} = Invites.create(%{
        content: "test-invite",
        code: "test-code",
        created_by_id: user.id,
        whiteboard_id: whiteboard.id
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
