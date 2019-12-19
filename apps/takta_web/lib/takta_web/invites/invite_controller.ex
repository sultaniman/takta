defmodule TaktaWeb.InviteController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.InviteService

  def create(
    %Plug.Conn{assigns: %{user: user}} = conn,
    params
  ) do
    response = InviteService.create_with_member(user, params)
    conn |> StatusResponse.send_response(response)
  end

def list(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
  response = InviteService.find_for_user(user)
  conn |> StatusResponse.send_response(response)
end

def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => invite_id}) do
  response = InviteService.detail_for_user(user, invite_id)
  conn |> StatusResponse.send_response(response)
end

def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => invite_id}) do
  response = InviteService.delete_invite(user, invite_id)
  conn |> StatusResponse.send_response(response)
end

  def accept_invite(
    %Plug.Conn{assigns: %{user: _user}} = _conn,
    %{"code" => _code}
  ) do
    # TODO: implement
    # validate & check
    # create magic token
    # exchange token to session
  end
end
