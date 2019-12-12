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

  def find_for_user(user) do
    invites =
      user.id
      |> Invites.find_for_user()
      |> Enum.map(&InviteMapper.to_json_basic/1)

    StatusResponse.ok(%{invites: invites})
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
end
