defmodule TaktaWeb.MagicController do
  use TaktaWeb, :controller
  alias Auth.{MagicTokens, Sessions}
  alias Takta.Accounts

  def magic_signin(conn, %{"magic_token" => token}) do
    case MagicTokens.find_token(token) do
      nil -> conn |> deny()
      magic_token -> conn |> verify_token(magic_token)
    end
  end

  # -------------
  defp verify_token(conn, magic_token) do
    case MagicTokens.is_valid?(magic_token.token) do
      true -> conn |> sign_in(magic_token.user_id)
      false -> conn |> deny()
    end
  end

  defp sign_in(conn, user_id) do
    case Accounts.find_by_id(user_id) do
      nil -> conn |> deny()
      _user ->
        session = get_or_create_session(user_id)
        conn
        |> put_session(:session_id, session.id)
        |> redirect(to: "/")
    end
  end

  defp get_or_create_session(user_id) do
    # Find valid session
    case Sessions.find_by_user_id(user_id) do
      nil ->
        {:ok, session} = Sessions.create(user_id)
        session

      session -> session
    end
  end

  defp deny(conn) do
    conn
    |> put_status(400)
    |> json(%{error: :invalid_token})
  end
end
