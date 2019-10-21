defmodule TaktaWeb.AuthController do
  use TaktaWeb, :controller

  alias TaktaWeb.AuthHelper

  plug(Ueberauth)

  def signin(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def signin(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    case AuthHelper.login(conn, auth, provider |> String.to_atom()) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: '/')

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: '/')
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: '/')
  end
end
