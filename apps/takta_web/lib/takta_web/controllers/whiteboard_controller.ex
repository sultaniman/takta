defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias Takta.Whiteboards
  alias TaktaWeb.Uploaders.S3

  @uploader Application.get_env(:takta_web, :uploader)

  def create(%Plug.Conn{assigns: %{user: user}} = conn, %{"filename" => filename, "data" => data}) do
    # TODO: save file, get path, create whiteboard
    case @uploader.upload(filename, data) do
      {:ok, path} ->
        {:ok, whiteboard} = Whiteboards.create(%{
          name: filename,
          path: path,
          owner_id: user.id
        })

        conn
        |> render("whiteboard.json", whiteboard)

      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(%{error: reason})
    end
  end
end
