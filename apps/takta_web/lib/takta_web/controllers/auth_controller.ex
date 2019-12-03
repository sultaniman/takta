defmodule TaktaWeb.AuthController do
  use TaktaWeb, :controller

  alias TaktaWeb.AuthHelper

  plug Ueberauth

  def signin(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> show_login(fails.errors, "Failed to authenticate.")
  end

  def signin(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    case AuthHelper.login(conn, auth, provider |> String.to_atom()) do
      {:ok, user} ->
        magic_link = AuthHelper.get_magic_link(conn, user.id, provider)
        conn |> redirect(to: magic_link)

      {:error, reason} ->
        conn
        |> show_login(reason, "Something went wrong during signin.")

      conn ->
        conn
        |> put_flash(:error, "You have already signed in with other platform.")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp show_login(conn, errors, message) do
    conn
    |> assign(:errors, errors)
    |> put_flash(:error, message)
    |> put_view(TaktaWeb.LoginView)
    |> render("signin.html")
  end
end
