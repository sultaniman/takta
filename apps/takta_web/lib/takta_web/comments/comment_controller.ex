defmodule TaktaWeb.CommentController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.CommentService

  def create(%Plug.Conn{assigns: %{user: user}} = conn, params) do
    result = CommentService.create_comment(user, params)
    conn |> StatusResponse.send_response(result)
  end

  def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => comment_id}) do
    response = CommentService.detail_for_user(comment_id, user)
    conn |> StatusResponse.send_response(response)
  end

  def update(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => comment_id, "comment" => params}) do
    response = CommentService.update_comment(comment_id, user, params)
    conn |> StatusResponse.send_response(response)
  end

  def update(conn, _params) do
    response = StatusResponse.not_found()
    conn |> StatusResponse.send_response(response)
  end

  def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => comment_id}) do
    response = CommentService.delete_comment(comment_id, user)
    conn |> StatusResponse.send_response(response)
  end

  def delete(conn, _params) do
    response = StatusResponse.not_found()
    conn |> StatusResponse.send_response(response)
  end
end
