defmodule TaktaWeb.CommentService do
  @moduledoc false
  alias Takta.{Annotations, Comments, Whiteboards}
  alias Takta.Annotations.AnnotationMapper
  alias Takta.Comments.{Comment, CommentMapper}
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Permissions
  alias TaktaWeb.Services.ServiceHelpers

  def create_comment(user, params) do
    whiteboard =
      params
      |> Map.get("whiteboard_id")
      |> Whiteboards.find_by_id()

    can_comment = Permissions.can_comment?(user, whiteboard)
    ServiceHelpers.call_if(
      fn _c -> create(Map.put(params, "author_id", user.id)) end,
      whiteboard,
      can_comment
    )
  end

  def detail_for_user(comment_id, user) do
    comment = Comments.find_by_id(comment_id)
    can_see = Permissions.can_see_comment?(user, comment)
    ServiceHelpers.call_if(&detail/1, comment, can_see)
  end

  def update_comment(comment_id, user, params) do
    comment = Comments.find_by_id(comment_id)
    can_manage = Permissions.can_manage_comment?(user, comment)
    ServiceHelpers.call_if(
      fn _c -> update(comment, params) end,
      comment,
      can_manage
    )
  end

  @doc """
  Deletes comment if the folllowing conditions met

    1. User is admin or,
    2. User is the author of comment.
  """
  def delete_comment(comment_id, user) do
    comment = Comments.find_by_id(comment_id)
    can_manage = Permissions.can_manage_comment?(user, comment)
    ServiceHelpers.call_if(&delete/1, comment, can_manage)
  end

  defp create(params) do
    case Comments.create(params) do
      {:ok, comment} ->
        if params |> Map.has_key?("coords") do
          comment
          |> create_annotation(params)
          |> StatusResponse.ok()
        else
          comment
          |> CommentMapper.to_json_basic()
          |> StatusResponse.ok()
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  defp detail(nil), do: StatusResponse.not_found()
  defp detail(%Comment{} = comment) do
    comment
    |> Comments.with_author()
    |> CommentMapper.to_json_extended()
    |> StatusResponse.ok()
  end
  defp detail(comment_id) do
    case Comments.find_by_id(comment_id) do
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

  def delete(comment) do
    case Comments.delete(comment.id) do
      {:ok, comment} ->
        comment
        |> CommentMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, :not_found} -> StatusResponse.not_found()
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
        |> Map.put("annotation", annotation |> AnnotationMapper.to_json_basic())

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
