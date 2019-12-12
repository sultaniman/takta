defmodule TaktaWeb.InviteService do
  @moduledoc false
  alias Takta.{Invites, Whiteboards}
  alias Takta.Invites.InviteMapper
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Permissions
  alias TaktaWeb.Services.ServiceHelpers

  def create_invite(user, whiteboard_id, params) do
    case Whiteboards.find_by_id(whiteboard_id) do
      nil -> StatusResponse.not_found()
      whiteboard ->
        can_manage = Permissions.can_manage_whiteboard(user, whiteboard)
        ServiceHelpers.call_if(
          fn _i ->
            params
            |> Map.merge(%{"code" => UUID.uuid4(), "used" => false, "created_by_id" => user.id})
            |> create()
          end,
          params,
          can_manage
        )
    end
  end

  def detail_for_user(user, invite_id) do
    case Invites.find_by_id(invite_id) do
      nil -> StatusResponse.not_found()
      invite ->
        if invite.created_by_id == user.id do
          invite
          |> Invites.preload_all()
          |> InviteMapper.to_json_extended()
          |> StatusResponse.ok()
        else
          StatusResponse.permission_denied()
        end
    end
  end

  def find_for_user(user) do
    invites =
      user.id
      |> Invites.find_for_user()
      |> Enum.map(&InviteMapper.to_json_basic/1)

    StatusResponse.ok(%{invites: invites})
  end

  def delete_invite(user, invite_id) do
    case Invites.find_by_id(invite_id) do
      nil -> StatusResponse.not_found()
      invite ->
        invite = Invites.preload_all(invite)
        if invite.created_by_id == user.id do
          delete(invite)
        else
          StatusResponse.permission_denied()
        end
    end
  end

  def invite_by_email(user, params) do
  end

  defp create(params) do
    case Invites.create(params) do
      {:ok, invite} ->
        invite
        |> InviteMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  def delete(invite) do
    case Invites.delete(invite.id) do
      {:ok, deleted_invite} ->
        deleted_invite
        |> InviteMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, :not_found} ->
        StatusResponse.not_found()
    end
  end
end
