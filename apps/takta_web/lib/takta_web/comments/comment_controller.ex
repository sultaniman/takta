defmodule TaktaWeb.CommentController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse

  def create(conn, _params) do
    conn |> StatusResponse.send_response(StatusResponse.ok())
  end

  def detail(conn, _params) do
    conn |> StatusResponse.send_response(StatusResponse.ok())
  end

  def update(conn, _params) do
    conn |> StatusResponse.send_response(StatusResponse.ok())
  end

  def delete(conn, _params) do
    conn |> StatusResponse.send_response(StatusResponse.ok())
  end
end
