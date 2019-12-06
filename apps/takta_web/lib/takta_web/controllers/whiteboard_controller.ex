defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services.UploadService
  alias TaktaWeb.Whiteboards.WhiteboardService

  def list(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
    response = WhiteboardService.list_for_user(user.id)
    conn |> StatusResponse.send_response(response)
  end

  def detail(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => wid}) do

  end

  def create(conn, params) do
    UploadService.handle_upload(conn, params)
  end

  def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => wid}) do
    response = WhiteboardService.delete_for_user(wid, user.id)
    conn |> StatusResponse.send_response(response)
  end
end
