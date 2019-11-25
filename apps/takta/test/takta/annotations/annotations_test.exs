defmodule Takta.AnnotationsTest do
  use Takta.{DataCase, Query}

  alias Takta.{
    Annotations,
    Comments,
    Whiteboards
  }

  describe "annotations 📌 ::" do
    test "find all works as expected" do
      assert Annotations.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Annotations.all() |> List.first()
      assert Annotations.find_by_id(one.id)
    end

    test "find_by_id returns nil if annotation not found" do
      refute Annotations.find_by_id(UUID.uuid4())
    end

    test "can create new annotation" do
      wb = Whiteboards.all() |> List.first()
      comment = Comments.all() |> List.first()

      {:ok, annotation} = Annotations.create(%{
        coords: %{
          x: 1,
          y: 2
        },
        comment_id: comment.id,
        whiteboard_id: wb.id
      })

      assert Annotations.find_by_id(annotation.id).id
    end

    test "can not create new comment if input is not valid" do
      {:error, changeset} = Annotations.create(%{})

      assert changeset.errors
      assert changeset.errors == [
        coords: {"can't be blank", [validation: :required]},
        comment_id: {"can't be blank", [validation: :required]},
        whiteboard_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update comment if input is valid" do
      annotation = Annotations.all() |> List.first()
      {:ok, updated} = Annotations.update(annotation, %{coords: %{x: 8, y: 8}})
      assert updated.coords == %{x: 8, y: 8}
    end

    test "can not update comment if input is not valid" do
      annotation = Annotations.all() |> List.first()
      {:error, changeset} = Annotations.update(annotation, %{coords: nil})

      assert changeset.errors
      assert changeset.errors == [
        coords: {"can't be blank", [validation: :required]}
      ]
    end

    test "can delete comment" do
      annotation = Annotations.all() |> List.first()
      assert {:ok, deleted} = Annotations.delete(annotation.id)
      assert deleted.id == annotation.id
    end

    test "can not delete comment if comment does not exist" do
      assert {:error, :not_found} = Annotations.delete(UUID.uuid4())
    end
  end
end
