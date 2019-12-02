defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Services.UploadService

  plug TaktaWeb.Plugs.AuthContext
  plug TaktaWeb.Plugs.AuthRequired

  def create(conn, params) do
    UploadService.handle_upload(conn, params)
  end
end
