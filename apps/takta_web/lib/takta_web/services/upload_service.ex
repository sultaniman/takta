defmodule TaktaWeb.Services.UploadService do
  @moduledoc false
  import Plug.Conn, only: [put_status: 2]
  import Phoenix.Controller, only: [json: 2, render: 3]
  import Takta.Image

  require Logger

  alias Takta.Whiteboards

  @uploader Application.get_env(:takta_web, :uploader)
  @upload_to Application.get_env(:takta_web, :upload_to)

  @doc """
  Handle upload and return response.
  Depending on environemnt takes responsibility to

    1. handle upload backends,
    2. validate image format,
  """
  def handle_upload(
    %Plug.Conn{assigns: %{user: user}} = conn,
    %{"filename" => filename, "data" => data}
  ) do
    image = Base.decode64!(data)

    case make_name(image, user.id) do
      nil ->
        conn
        |> put_status(400)
        |> json(%{error: :invalid_format})

      path ->
        case @uploader.upload(path, image) do
          {:ok, _s3_path} ->
            params = %{name: filename, path: path, owner_id: user.id}
            create_whiteboard(conn, params)

          {:error, reason} ->
            conn
            |> put_status(400)
            |> json(%{error: reason})
        end
    end
  end

  defp create_whiteboard(conn, params) do
    case Whiteboards.create(params) do
      {:ok, whiteboard} ->
        conn
        |> render("whiteboard.json", whiteboard)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = %{
          error: :validation,
          details: Takta.Util.Changeset.errors_to_json(changeset)
        }

        conn
        |> put_status(400)
        |> json(errors)
    end
  end

  defp make_name(binary_image, user_id) do
    case extension(binary_image) do
      nil -> nil
      ext ->
        name = UUID.uuid4(:hex) <> ext

        if is_valid?(ext) do
          if @uploader.name_only? do
            [user_id, name] |> Path.join()
          else
            [@upload_to, user_id, name] |> Path.join()
          end
        else
          nil
        end
    end
  end
end
