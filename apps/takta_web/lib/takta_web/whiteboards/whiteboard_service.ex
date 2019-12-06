defmodule TaktaWeb.Whiteboards.WhiteboardService do
  @moduledoc """
  Whiteboard service carries business logic of handling
  certain operations and related responses.
  """
  alias Takta.Accounts
  alias Takta.Whiteboards
  alias Takta.Whiteboards.Whiteboard
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Whiteboards.WhiteboardMapper

  def list_for_user(user_id) do
    whiteboards =
      user_id
      |> Whiteboards.find_for_user()
      |> Enum.map(&WhiteboardMapper.to_json_basic/1)

    StatusResponse.ok(%{whiteboards: whiteboards})
  end

  @doc """
  Delete whiteboard with `wid` for user with `user_id`.
  Unless the user found and is owner of the whiteboard
  not found or permission denied errors will be returned
  """
  def delete_for_user(wid, user_id) do
    wb = Whiteboards.find_by_id(wid)
    user = Accounts.find_by_id(user_id)

    if is_nil(wb) or is_nil(user) do
      StatusResponse.not_found()
    else
      if Whiteboards.has_owner(wid, user_id) do
        delete(wid)
      else
        StatusResponse.permission_denied()
      end
    end
  end

  def delete(wid) do
    case Whiteboards.delete(wid) do
      {:ok, %Whiteboard{} = wb} -> StatusResponse.ok(WhiteboardMapper.to_json_basic(wb))
      {:error, :not_found} -> StatusResponse.not_found()
      {:error, details} -> StatusResponse.server_error(details)
    end
  end
end
