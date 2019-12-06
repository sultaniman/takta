defmodule TaktaWeb.Base.StatusResponse do
  @moduledoc false
  import Plug.Conn, only: [put_status: 2]
  import Phoenix.Controller, only: [json: 2]

  def ok(nil), do: {200, %{status: :ok}}
  def ok(response), do: {200, response}

  def auth_required(nil), do: {401, %{error: :auth_required}}
  def auth_required(reason), do: {401, %{error: :auth_required, details: reason}}

  def not_found, do: {404, %{error: :not_found}}

  def server_error(nil), do: {500, %{error: :server_error}}
  def server_error(reason), do: {500, %{error: :server_error, details: reason}}

  def send_response(conn, {status, response}) do
    conn
    |> put_status(status)
    |> json(response)
  end
end
