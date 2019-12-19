defmodule TaktaWeb.InviteService do
  @moduledoc false
  alias Takta.{
    Collections,
    Invites,
    Members,
    Whiteboards
  }

  alias Takta.Invites.InviteMapper
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Permissions
  alias TaktaWeb.Services.ServiceHelpers

  def create_invite(user, params) do
    # TODO: check if collection or whiteboard given
    # check permissions if things are fine then
    # Create membership then create invite
    # Then send invite via email.
    whiteboard =
      params
      |> Map.get("whiteboard_id")
      |> Whiteboards.find_by_id()

    collection =
      params
      |> Map.get("collection_id")
      |> Collections.find_by_id()

    member_id = params |> get_in("member_id")

    if is_nil(whiteboard) and is_nil(collection) do
      StatusResponse.not_found()
    else
      if member_id == user.id do
        StatusResponse.bad_request(:already_owner)
      else
        can_manage_collection = Permissions.can_manage_collection?(user, collection)
        can_manage_whiteboard = Permissions.can_manage_whiteboard?(user, whiteboard)

        if can_manage_collection or can_manage_whiteboard do
          case Members.create(params) do
            {:ok, member} ->
              ServiceHelpers.call_if(
                fn _i ->
                  new_params =
                    params
                    |> Map.merge(%{
                      "code" => UUID.uuid4(),
                      "used" => false,
                      "created_by_id" => user.id,
                      "member_id" => member.id
                    })

                  new_params |> create()
                end,
                params,
                true
              )

            {:error, %Ecto.Changeset{} = changeset} ->
              changeset
              |> Takta.Util.Changeset.errors_to_json()
              |> StatusResponse.bad_request()
          end
        end
      end
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

  defp create(params) do
    case Invites.create(params) do
      {:ok, invite} ->
        invite |> send_invite()

        invite
        |> InviteMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end

  defp delete(invite) do
    case Invites.delete(invite.id) do
      {:ok, deleted_invite} ->
        deleted_invite
        |> InviteMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, :not_found} ->
        StatusResponse.not_found()
    end
  end

  defp send_invite(_invite) do
    # TODO: implement link generation
    # and putting data together
    # and sending email
    # Mailer.Invite.create_invite(invite.member.user.email, "https://magiclink", is_collection)
  end
end
