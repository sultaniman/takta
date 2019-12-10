defmodule Takta.WhiteboarsTest do
  use Takta.{DataCase, Query}
  alias Takta.{Accounts, Whiteboards}

  describe "whiteboards 🚧 ::" do
    test "find all works as expected" do
      assert Whiteboards.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Whiteboards.all() |> List.first()
      assert Whiteboards.find_by_id(one.id)
    end

    test "find_by_id returns nil if whiteboard not found" do
      refute Whiteboards.find_by_id(UUID.uuid4())
    end

    test "can access comments" do
      wb =
        Whiteboards.all()
        |> List.first()
        |> Whiteboards.with_comments()

      assert length(wb.comments) == 4
    end

    test "can access annotations" do
      wb =
        Whiteboards.all()
        |> List.first()
        |> Whiteboards.with_annotations()

      assert length(wb.annotations) == 2
    end

    test "can create new whiteboard" do
      user = Accounts.all() |> List.first()

      {:ok, wb} = Whiteboards.create(%{
        name: "test-wb",
        path: "path/to/file.png",
        owner_id: user.id
      })

      assert Whiteboards.find_by_id(wb.id).id == wb.id
    end

    test "can not create new whiteboard if input is not valid" do
      {:error, changeset} = Whiteboards.create(%{
        name: "test-wb",
        path: "path/to/file.png",
      })

      assert changeset.errors
      assert changeset.errors == [
        owner_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update whiteboard if input is valid" do
      whiteboard = Whiteboards.all() |> List.first()
      {:ok, updated} = Whiteboards.update(whiteboard, %{name: "Spider man"})
      assert updated.name == "Spider man"
    end

    test "can not update whiteboard if input is not valid" do
      whiteboard = Whiteboards.all() |> List.first()
      {:error, changeset} = Whiteboards.update(whiteboard, %{owner_id: nil})

      assert changeset.errors
      assert changeset.errors == [
        owner_id: {"can't be blank", [validation: :required]}
      ]
    end
  end
end
