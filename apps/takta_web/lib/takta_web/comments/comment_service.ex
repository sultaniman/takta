defmodule TaktaWeb.CommentService do
  @moduledoc false
  alias Takta.{Comments, Members}
  alias Takta.Comments.{Comment, CommentMapper}
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Permissions

  def create(params) do
    case Comments.create(params) do
      {:ok, comment} ->
        comment
        |> CommentMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  def detail_for_user(comment_id, user) do
    comment = Comments.find_by_id(comment_id)
    case Permissions.can_see_comment(user, comment) do
      true -> detail(comment)
      false -> StatusResponse.permission_denied()
    end
  end

  defp detail(nil), do: StatusResponse.not_found()
  defp detail(%Comment{} = comment) do
    comment
    |> Comments.with_author()
    |> CommentMapper.to_json_extended()
    |> StatusResponse.ok()
  end
  defp detail(cid) do
    case Comments.find_by_id(cid) do
      nil -> StatusResponse.not_found()
      comment ->
        comment
        |> Comments.with_author()
        |> CommentMapper.to_json_extended()
        |> StatusResponse.ok()
    end
  end
end
