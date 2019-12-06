defmodule TaktaWeb.Base.StatusResponse do
  @moduledoc """
  Contains pre-baked http responses,
  if provided details should have the following
  shape

  ```json
  {
    "error": "permission_denied",
    "details": [
      {"code": "wrong_user"},
      {"code": "user_not_found"},
    ]
  }
  ```
  """
  import Plug.Conn, only: [put_status: 2]
  import Phoenix.Controller, only: [json: 2]

  def ok, do: {200, %{status: :ok}}
  def ok(response), do: {200, response}

  def auth_required, do: {401, %{error: :auth_required}}
  def auth_required(reason), do: {401, %{error: :auth_required, details: reason}}

  def not_found, do: {404, %{error: :not_found}}
  def not_found(reason), do: {404, %{error: :not_found, details: reason}}

  def permission_denied, do: {403, %{error: :permission_denied}}
  def permission_denied(reason), do: {403, %{error: :permission_denied, details: reason}}

  def server_error, do: {500, %{error: :server_error}}
  def server_error(reason), do: {500, %{error: :server_error, details: reason}}

  def send_response(conn, {status, response}) do
    conn
    |> put_status(status)
    |> json(response)
  end
end
