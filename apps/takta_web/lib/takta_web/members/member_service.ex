defmodule TaktaWeb.MemberService do
  @moduledoc false
  alias Takta.{Accounts, Members, Whiteboards}
  alias Takta.Members.MemberMapper
  alias TaktaWeb.Permissions
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services.ServiceHelpers

  # TODO: create invite -> send by email
  # TODO: update method -> check collection_id as well
  def create_member(user, params) do
    whiteboard =
      params
      |> Map.get("whiteboard_id")
      |> Whiteboards.find_by_id()

    member_id =
      params
      |> Map.get("member_id")

    if member_id == user.id do
      StatusResponse.bad_request(:already_owner)
    else
      can_manage = Permissions.can_manage_whiteboard?(user, whiteboard)
      ServiceHelpers.call_if(&create/1, params, can_manage)
    end
  end

  def detail_for_user(user, member_id) do
    case Members.find_by_id(member_id) do
      nil -> StatusResponse.not_found()
      member ->
        user = Accounts.find_by_id(user.id)
        whiteboard =
          member.whiteboard_id
          |> Whiteboards.find_by_id()

        if Permissions.can_manage_whiteboard?(user, whiteboard) do
          member
          |> Members.preload_all()
          |> MemberMapper.to_json_extended()
          |> StatusResponse.ok()
        else
          StatusResponse.permission_denied()
        end
    end
  end

  def update_member(member_id, user, permissions) do
    case Members.find_by_id(member_id) do
      nil -> StatusResponse.not_found()

      member ->
        whiteboard = Whiteboards.find_by_id(member.whiteboard_id)
        can_manage = Permissions.can_manage_whiteboard?(user, whiteboard)
        ServiceHelpers.call_if(
          fn _m ->
            update(member, %{
              can_comment: Map.get(permissions, "can_comment"),
              can_annotate: Map.get(permissions, "can_annotate")
            })
          end,
          member,
          can_manage
        )
    end
  end

  def delete_member(user, member_id) do
    case Members.find_by_id(member_id) do
      nil -> StatusResponse.not_found()

      member ->
        whiteboard = Whiteboards.find_by_id(member.whiteboard_id)
        can_manage = Permissions.can_manage_whiteboard?(user, whiteboard)
        ServiceHelpers.call_if(&delete/1, member, can_manage)
    end
  end

  defp create(params) do
    case Members.create(params) do
      {:ok, member} ->
        member
        |> MemberMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  defp update(member, params) do
    case Members.update(member, params) do
      {:ok, updated_member} ->
        updated_member
        |> MemberMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  defp delete(member) do
    case Members.delete(member.id) do
      {:ok, deleted_member} ->
        deleted_member
        |> MemberMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, :not_found} ->
        StatusResponse.not_found()
    end
  end
end
