defmodule TaktaWeb.AuthRequiredTest do
  use TaktaWeb.ConnCase, async: true

  alias Auth.Sessions
  alias Takta.Accounts
  alias TaktaWeb.Plugs.AuthRequired

  describe "🔌 - auth required 🔐 ::" do
    test "it works as expected if session set and user exists for it", %{conn: conn} do
      {:ok, user} = Accounts.create(%{
        email: "auth-required@example.com",
        full_name: "Auth required",
        password: "12345678",
        is_active: true,
        is_admin: true
      })

      {:ok, session} = Sessions.create(user.id)

      conn =
        conn
        |> Plug.Test.init_test_session(session_id: session.id)
        |> assign(:authenticated, true)
        |> AuthRequired.call(%{})

      assert conn.status != 401
    end

    test "it works as expected if user for session does not exist", %{conn: conn} do
      {:ok, session} = Sessions.create(UUID.uuid4())

      conn =
        conn
        |> Plug.Test.init_test_session(session_id: session.id)
        |> assign(:authenticated, true)
        |> AuthRequired.call(%{})

      assert conn.status == 401
    end

    test "it works as expected if session does not exist", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(session_id: UUID.uuid4())
        |> assign(:authenticated, true)
        |> AuthRequired.call(%{})

      assert conn.status == 401
    end
  end
end
