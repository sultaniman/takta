defmodule TaktaWeb.MagicControllerTest do
  use TaktaWeb.ConnCase, async: true
  alias Auth.{MagicTokens, Sessions}
  alias Takta.Accounts

  describe "magic controller ✨ ::" do
    test "endpoint is accessible with valid token", %{conn: conn} do
      {:ok, user1} = Accounts.create(%{
        email: "user-jwt@example.com",
        full_name: "User name",
        password: "12345678",
        is_active: true,
        is_admin: true
      })

      {:ok, magic_token} = MagicTokens.create_token(user1.id)

      conn
      |> get(Routes.magic_path(conn, :magic_signin, magic_token.token))
      |> html_response(302)
    end

    test "session id is set once signed in", %{conn: conn} do
      {:ok, user1} = Accounts.create(%{
        email: "user-jwt@example.com",
        full_name: "User name",
        password: "12345678",
        is_active: true,
        is_admin: true
      })

      {:ok, magic_token} = MagicTokens.create_token(user1.id)

      session_id =
        conn
        |> get(Routes.magic_path(conn, :magic_signin, magic_token.token))
        |> get_session("session_id")

      assert session_id
      assert (%Sessions.Session{} = _session) = Sessions.find_by_id(session_id)
    end

    test "endpoint returns HTTP 400 with invalid token", %{conn: conn} do
      conn
      |> get(Routes.magic_path(conn, :magic_signin, UUID.uuid4()))
      |> json_response(400)
    end
  end
end
