defmodule TaktaWeb.InviteService do
  @moduledoc false
  alias Auth.Magic
  alias Auth.MagicTokens
  alias Mailer.Invite
  alias Takta.{
    Accounts,
    Collections,
    Invites,
    Members,
    Whiteboards
  }

  alias Takta.Invites.InviteMapper
  alias Takta.Util.Changeset
  alias TaktaWeb.Permissions
  alias TaktaWeb.Router.Helpers

  import TaktaWeb.Base.StatusResponse

  def detail_for_user(user, invite_id) do
    case Invites.find_by_id(invite_id) do
      nil -> not_found()
      invite ->
        if invite.created_by_id == user.id do
          invite
          |> Invites.preload_all()
          |> InviteMapper.to_json_extended()
          |> ok()
        else
          permission_denied()
        end
    end
  end

  def find_for_user(user) do
    invites =
      user.id
      |> Invites.find_for_user()
      |> Enum.map(&InviteMapper.to_json_basic/1)

    ok(%{invites: invites})
  end

  # TODO: write unit test
  def accept_invite(code) do
    case Invites.find_by_code(code) do
      nil -> {:error, :not_found}
      invite ->
        case Magic.decode_and_verify(invite.code) do
          {:ok, _claims} ->
            {:ok, magic_token} = MagicTokens.create_token(invite.member.member_id, "invite")
            Accounts.activate_user(invite.member.member_id)
            {:ok, magic_token.token}
          {:error, _reason} -> {:error, :invalid_invite}
        end
    end
  end

  def delete_invite(user, invite_id) do
    case Invites.find_by_id(invite_id) do
      nil -> not_found()
      invite ->
        invite = Invites.preload_all(invite)
        if invite.created_by_id == user.id do
          delete(invite)
        else
          permission_denied()
        end
    end
  end

  @doc """
  Creates invite and member membership
  """
  def create_with_member(user, params) do
    case validate_member(user, params) do
      # Means both collection and whiteboard
      # do not exist in our database, thus HTTP 404
      {nil, nil, _has_permission, _same_user} ->
        not_found()

      # Means user has insufficient permissions
      {_collection, _whiteboard, false, _} ->
        permission_denied()

      # Means user can not invite himself
      {_collection, _whiteboard, _, true} ->
        bad_request(:already_owner)

      # Happy path, when user is the
      # owner of collection or whiteboard
      # and has 0
      {_collection, _whiteboard, true, false} ->
        with {:ok, member_user} <- get_or_create_user(params) do
          member_params =
            params
            |> Map.merge(%{"member_id" => member_user.id})

          user |> create_member(member_params)
        else
          error_response -> error_response
        end
    end
  end

  ### Helper code
  defp create(params, member) do
    case Invites.create(params) do
      {:ok, invite} ->
        member
        |> Members.preload_all()
        |> send_invite(invite.code)

        invite
        |> InviteMapper.to_json_basic()
        |> ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Changeset.errors_to_json()
        |> bad_request()
    end
  end

  defp delete(invite) do
    case Invites.delete(invite.id) do
      {:ok, deleted_invite} ->
        deleted_invite
        |> InviteMapper.to_json_basic()
        |> ok()

      {:error, :not_found} ->
        not_found()
    end
  end

  defp validate_member(user, member_params) do
    whiteboard =
      member_params
      |> Map.get("whiteboard_id")
      |> Whiteboards.find_by_id()

    collection =
      member_params
      |> Map.get("collection_id")
      |> Collections.find_by_id()

    member_id = Map.get(member_params, "member_id")
    has_permissions = user |> can_manage(collection, whiteboard)
    same_user = member_id == user.id

    {
      collection,
      whiteboard,
      has_permissions,
      same_user
    }
  end

  defp create_member(from_user, params) do
    case Members.create(params) do
      {:ok, member} ->
        create(%{
          "code" => get_code(member.id),
          "used" => false,
          "created_by_id" => from_user.id,
          "member_id" => member.id
        }, member)

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Changeset.errors_to_json()
        |> bad_request()
    end
  end

  defp can_manage(user, collection, whiteboard) do
    can_manage_collection = Permissions.can_manage_collection?(user, collection)
    can_manage_whiteboard = Permissions.can_manage_whiteboard?(user, whiteboard)
    can_manage_collection or can_manage_whiteboard
  end

  defp get_or_create_user(params) do
    get_or_create_user(
      Map.get(params, "member_id"),
      Map.get(params, "email")
    )
  end
  defp get_or_create_user(user_id, nil) do
    {:ok, Accounts.find_by_id(user_id)}
  end
  defp get_or_create_user(nil, email) do
    case Accounts.find_by_email(email) do
      nil ->
        case Accounts.create_from_email(email) do
          {:ok, user} -> {:ok, user}
          {:error, %Ecto.Changeset{} = changeset} ->
            changeset
            |> Changeset.errors_to_json()
            |> bad_request()
        end

      user -> {:ok, user}
    end
  end

  defp send_invite(membership, code) do
    domain =
      :takta_web
      |> Application.get_env(TaktaWeb.Endpoint)

    path =
      TaktaWeb.Endpoint
      |> Helpers.invite_path(:accept_invite, code)

    link = domain[:url][:host] <> path

    membership.member.email
    |> Invite.create_invite(link, membership.collection_id != nil)
    |> Invite.schedule_delivery()
  end

  defp get_code(user_id) do
    with {:ok, token, _claims} <- user_id |> Magic.encode_and_sign() do
      token
    end
  end
end
