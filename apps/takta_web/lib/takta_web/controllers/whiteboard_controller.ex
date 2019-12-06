defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services.UploadService
  alias TaktaWeb.Whiteboards.WhiteboardService

  def create(conn, params) do
    UploadService.handle_upload(conn, params)
  end

  def delete(conn, %{"id" => wid}) do
    with result <- WhiteboardService.delete(wid) do
      conn |> StatusResponse.send_response(result)
    end
  end
end
