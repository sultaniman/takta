defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services.UploadService
  alias TaktaWeb.{CommentService, MemberService, WhiteboardService}

  def list(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
    response = WhiteboardService.list_for_user(user.id)
    conn |> StatusResponse.send_response(response)
  end

  def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => wid}) do
    response = WhiteboardService.details_for_user(wid, user.id)
    conn |> StatusResponse.send_response(response)
  end

  def create(conn, params) do
    UploadService.handle_upload(conn, params)
  end

  def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => wid}) do
    response = WhiteboardService.delete_for_user(wid, user.id)
    conn |> StatusResponse.send_response(response)
  end

  def comment(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => id, "content" => content}) do
    response = CommentService.create_comment(user, %{
      "whiteboard_id" => id,
      "content" => content
    })

    conn |> StatusResponse.send_response(response)
  end

  def create_member(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => id, "member" => params}) do
    response = MemberService.create_member(user, %{
      "can_annotate" => Map.get(params, "can_annotate"),
      "can_comment" => Map.get(params, "can_comment"),
      "member_id" => Map.get(params, "member_id"),
      "whiteboard_id" => id
    })

    conn |> StatusResponse.send_response(response)
  end
end
