defmodule TaktaWeb.AuthController do
  use TaktaWeb, :controller

  alias TaktaWeb.SocialAuthHelpers

  plug Ueberauth

  def signin(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> SocialAuthHelpers.show_login(fails.errors, "Failed to authenticate.")
  end

  def signin(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    conn
    |> SocialAuthHelpers.authenticate(auth, provider |> String.to_atom())
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
