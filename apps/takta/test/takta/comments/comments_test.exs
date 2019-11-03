defmodule Takta.CommentsTest do
  use Takta.{DataCase, Query}
  alias Takta.{Accounts, Comments}

  describe "comments 💬 ::" do
    test "find all works as expected" do
      assert Comments.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Comments.all() |> List.first()
      assert Comments.find_by_id(one.id)
    end

    test "find_by_id returns nil if comment not found" do
      refute Comments.find_by_id(UUID.uuid4())
    end

    test "can create new comment" do
      user = Accounts.all() |> List.first()

      {:ok, comment} = Comments.create(%{
        content: "test-comment",
        author_id: user.id
      })

      assert Comments.find_by_id(comment.id).id
    end

    test "can not create new comment if input is not valid" do
      {:error, changeset} = Comments.create(%{
        content: "test-comment"
      })

      assert changeset.errors
      assert changeset.errors == [
        author_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can update comment if input is valid" do
      comment = Comments.all() |> List.first()
      {:ok, updated} = Comments.update(comment, %{content: "Spider man"})
      assert updated.content == "Spider man"
    end

    test "can not update comment if input is not valid" do
      comment = Comments.all() |> List.first()
      {:error, changeset} = Comments.update(comment, %{author_id: nil})

      assert changeset.errors
      assert changeset.errors == [
        author_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "can delete comment" do
      comment = Comments.all() |> List.first()
      {:ok, deleted} = Comments.delete(comment.id)
      assert deleted.id == comment.id
    end

    test "can not delete comment if comment does not exist" do
      assert {:error, :not_found} = Comments.delete(UUID.uuid4())
    end
  end
end
