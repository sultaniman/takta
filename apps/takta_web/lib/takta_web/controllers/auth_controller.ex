defmodule TaktaWeb.AuthController do
  use TaktaWeb, :controller

  alias Auth.MagicTokens
  alias TaktaWeb.AuthHelper
  alias TaktaWeb.Router

  plug Ueberauth

  def signin(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def signin(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    # TODO: token to session exchange
    case AuthHelper.login(conn, auth, provider |> String.to_atom()) do
      {:ok, user} ->
        {:ok, magic_token} = MagicTokens.create_token(user.id, "social")

        magic_signing =
          conn
          |> Router.Helpers.magic_path(:magic_signin, magic_token.token)

        conn
        |> put_flash(:info, "Welcome back...")
        |> redirect(to: magic_signing)

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
