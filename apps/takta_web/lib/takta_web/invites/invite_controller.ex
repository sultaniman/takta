defmodule TaktaWeb.InviteController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.InviteService

  def create(
    %Plug.Conn{assigns: %{user: user}} = conn,
    params
  ) do
    response = InviteService.create_invite(user, params)
    conn |> StatusResponse.send_response(response)
  end

  # def list(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
  #   response = InviteService.find_for_user(user)
  #   conn |> StatusResponse.send_response(response)
  # end

  # def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => invite_id}) do
  #   response = InviteService.detail_for_user(user, invite_id)
  #   conn |> StatusResponse.send_response(response)
  # end

  # def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => invite_id}) do
  #   response = InviteService.delete_invite(user, invite_id)
  #   conn |> StatusResponse.send_response(response)
  # end

  # def email_invite(%Plug.Conn{assigns: %{user: user}} = conn, params) do
  #   response = InviteService.invite_by_email(user, params)
  #   conn |> StatusResponse.send_response(response)
  # end
end
