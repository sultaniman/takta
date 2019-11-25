defmodule TaktaWeb.AuthController do
  use TaktaWeb, :controller

  alias TaktaWeb.AuthHelper

  plug Ueberauth

  def signin(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def signin(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    case AuthHelper.login(conn, auth, provider |> String.to_atom()) do
      {:ok, user} ->
        magic_link = AuthHelper.get_magic_link(conn, user.id, provider)
        conn |> redirect(to: magic_link)

      # TODO: display message on signin page
      {:error, _reason} ->
        conn |> redirect(to: "/")

      # TODO: display message on signin page
      conn ->
        conn
        |> put_flash(:error, "You have already signed in with other platform")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
