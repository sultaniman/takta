defmodule TaktaWeb.WhiteboardController do
  @moduledoc false
  use TaktaWeb, :controller
  alias Takta.Whiteboards
  alias TaktaWeb.Uploaders.S3

  def create(%Plug.Conn{assigns: %{user: user}} = conn, %{"whiteboard" => data}) do
    # TODO: save file, get path, create whiteboard
    case S3.upload(data.filename, data.data) do
      {:ok, path} ->
        {:ok, whiteboard} = Whiteboards.create(%{
          name: data.filename,
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
