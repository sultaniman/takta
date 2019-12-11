defmodule TaktaWeb.MemberService do
  @moduledoc false
  alias Takta.{Members, Whiteboards}
  alias Takta.Members.MemberMapper
  alias TaktaWeb.Permissions
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services.ServiceHelpers

  def create_member(user, params) do
    whiteboard =
      params
      |> Map.get("whiteboard_id")
      |> Whiteboards.find_by_id()

    member_id =
      params
      |> Map.get("member_id")

    if member_id == user.id do
      StatusResponse.bad_request(%{message: :already_owner})
    else
      can_manage = Permissions.can_manage_whiteboard(user, whiteboard)
      ServiceHelpers.call_if(&create/1, params, can_manage)
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
end
