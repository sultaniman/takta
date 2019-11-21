defmodule TaktaWeb.AuthUtil do
  @moduledoc false
  import Plug.Conn, only: [put_session: 3, put_status: 2]
  import Phoenix.Controller, only: [json: 2, redirect: 2]

  alias Auth.{MagicTokens, Sessions}
  alias Takta.Accounts

  def maybe_authenticate(conn, magic_token) do
    case MagicTokens.is_valid?(magic_token.token) do
      true -> conn |> sign_in(magic_token.user_id)
      false -> conn |> deny()
    end
  end

  def sign_in(conn, user_id) do
    case Accounts.find_by_id(user_id) do
      nil -> conn |> deny()
      _user ->
        session = Sessions.get_or_create(user_id)

        conn
        |> put_session(:session_id, session.id)
        |> redirect(to: "/")
    end
  end

  def deny(conn) do
    conn
    |> put_status(400)
    |> json(%{error: :invalid_token})
  end
end
