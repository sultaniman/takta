defmodule TaktaWeb.CommentService do
  @moduledoc false
  alias Takta.{Annotations, Comments}
  alias Takta.Comments.{Comment, CommentMapper}
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Permissions

  def create(params) do
    case Comments.create(params) do
      {:ok, comment} ->
        comment
        |> create_annotation(params)
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  def detail_for_user(comment_id, user) do
    case Comments.find_by_id(comment_id) do
      nil -> StatusResponse.not_found()
      comment ->
        case Permissions.can_see_comment(user, comment) do
          true -> detail(comment)
          false -> StatusResponse.permission_denied()
        end
    end
  end

  def update_comment(comment_id, user, params) do
    case Comments.find_by_id(comment_id) do
      nil -> StatusResponse.not_found()
      comment ->
        case Permissions.can_manage_comment(user, comment) do
          true -> update(comment, params)
          false -> StatusResponse.permission_denied()
        end
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

  defp update(comment, params) do
    case Comments.update(comment, params) do
      {:ok, updated_comment} ->
        updated_comment
        |> CommentMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  defp create_annotation(comment, params) do
    params = %{
      comment_id: comment.id,
      whiteboard_id: comment.whiteboard_id,
      coords: params |> Map.get("coords")
    }

    case Annotations.create(params) do
      {:ok, annotation} ->
        comment
        |> CommentMapper.to_json_basic()
        |> Map.put("annotation", annotation)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors =
          changeset
          |> Takta.Util.Changeset.errors_to_json()

        comment
        |> CommentMapper.to_json_basic()
        |> Map.put("annotation", %{errors: errors})
    end
  end
end
