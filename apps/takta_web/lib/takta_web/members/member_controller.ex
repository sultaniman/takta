defmodule TaktaWeb.MemberController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.MemberService

  def create(%Plug.Conn{assigns: %{user: user}} = conn, params) do
    response = MemberService.create_member(user, params)
    conn |> StatusResponse.send_response(response)
  end

  def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => member_id}) do
    response = MemberService.detail_for_user(user, member_id)
    conn |> StatusResponse.send_response(response)
  end

  def update(
    %Plug.Conn{assigns: %{user: user}} = conn,
    %{"id" => member_id, "permissions" => permissions}
  ) do
    response = MemberService.update_member(member_id, user, permissions)
    conn |> StatusResponse.send_response(response)
  end

  def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => member_id}) do
    response = MemberService.delete_member(user, member_id)
    conn |> StatusResponse.send_response(response)
  end
end
