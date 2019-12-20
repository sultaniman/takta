defmodule TaktaWeb.InviteController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.{InviteService, Router}

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

  def accept_invite(conn, %{"code" => code}) do
    case InviteService.accept_invite(code) do
      {:ok, magic_token} ->
        signin_link =
          conn
          |> Router.Helpers.magic_path(:magic_signin, magic_token)

        conn |> redirect(to: signin_link)

      {:error, :not_found} ->
        conn |> StatusResponse.send_response(StatusResponse.not_found())

      {:error, :invalid_invite} ->
        conn |> StatusResponse.send_response(StatusResponse.bad_request(:invalid_invite))
    end
  end
end
