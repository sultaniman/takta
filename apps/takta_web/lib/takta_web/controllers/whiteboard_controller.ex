defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Services.{UploadService, WhiteboardService}

  def create(conn, params) do
    UploadService.handle_upload(conn, params)
  end

  def delete(conn, %{"id" => wid}) do
    with {status, response} <- WhiteboardService.delete(wid) do
      conn
      |> put_status(status)
      |> json(response)
    end
  end
end
