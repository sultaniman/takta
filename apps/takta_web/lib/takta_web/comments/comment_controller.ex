defmodule TaktaWeb.CommentController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.CommentService

  def create(conn, params) do
    result = CommentService.create(params)
    conn |> StatusResponse.send_response(result)
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
