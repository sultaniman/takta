defmodule TaktaWeb.AuthContextTest do
  use TaktaWeb.ConnCase, async: true

  alias Auth.Sessions
  alias Takta.Accounts
  alias TaktaWeb.Plugs.AuthContext

  describe "plug 🔌 - auth context 🍭 ::" do
    test "it works as expected if session is valid and user exists", %{conn: conn} do
      {:ok, user} = Accounts.create(%{
        email: "auth-context@example.com",
        full_name: "Auth context",
        password: "12345678",
        is_active: true,
        is_admin: true
      })

      {:ok, session} = Sessions.create(user.id)

      conn =
        conn
        |> Plug.Test.init_test_session(session_id: session.id)
        |> AuthContext.call(%{})

      assert conn.assigns.authenticated
      assert conn.assigns.user.id == user.id
    end

    test "it works as expected if session created for non existing user", %{conn: conn} do
      {:ok, session} = Sessions.create(UUID.uuid4())

      conn =
        conn
        |> Plug.Test.init_test_session(session_id: session.id)
        |> AuthContext.call(%{})

      refute conn.assigns.authenticated
      refute conn.assigns.user
    end

    test "it works as expected if session is not set", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(session_id: nil)
        |> AuthContext.call(%{})

      refute conn.assigns.authenticated
      refute conn.assigns.user
    end
  end
end
