defmodule TaktaWeb.CollectionController do
  @moduledoc false
  use TaktaWeb, :controller
  alias TaktaWeb.CollectionService
  alias TaktaWeb.Base.StatusResponse

  # TODO: add whiteboard test to check if can assign to collection
  def create(%Plug.Conn{assigns: %{user: user}} = conn, params) do
    response = CollectionService.create_for_user(user, params)
    StatusResponse.send_response(conn, response)
  end

  def list(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
    response = CollectionService.list_for_user(user)
    StatusResponse.send_response(conn, response)
  end

  def detail(
    %Plug.Conn{assigns: %{user: user}} = conn,
    %{"id" => collection_id}
  ) do
    response = CollectionService.detail_for_user(user, collection_id)
    StatusResponse.send_response(conn, response)
  end

  def update(
    %Plug.Conn{assigns: %{user: user}} = conn,
    %{"id" => collection_id, "name" => name}
  ) do
    response = CollectionService.update_for_user(user, collection_id, name)
    StatusResponse.send_response(conn, response)
  end

  def delete(%Plug.Conn{assigns: %{user: user}} = conn, %{"id" => collection_id}) do
    response = CollectionService.delete_for_user(user, collection_id)
    StatusResponse.send_response(conn, response)
  end

  def show_whiteboards(
    %Plug.Conn{assigns: %{user: user}} = conn,
    %{"id" => collection_id}
  ) do
    response = CollectionService.whiteboards_for_user(user, collection_id)
    StatusResponse.send_response(conn, response)
  end
end
