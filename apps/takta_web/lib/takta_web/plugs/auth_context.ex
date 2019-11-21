defmodule TaktaWeb.Plugs.AuthContext do
  @moduledoc false
  import Plug.Conn

  alias Auth.Sessions
  alias Takta.Accounts
  alias TaktaWeb.Plugs.Util

  require Logger

  def init(_params) do
  end

  @doc """
  Call does the following things:

    1. Tries to get current `:session_id`,
    2. If `:session_id` is found,
    3. Then check if session is valid,
    4. If session is valid,
    5. Then find user,
    6. And assign to request,
    7. Else set nil values on request.
  """
  def call(conn, _params) do
    session =
      conn
      |> get_session(:session_id)
      |> Sessions.find_by_id()

    case session |> Util.get_user_from_session() do
      nil -> conn |> no_user()
      user ->
        conn
        |> assign(:user, user)
        |> assign(:authenticated, true)
    end
  end

  defp no_user(conn) do
    conn
    |> assign(:user, nil)
    |> assign(:authenticated, false)
  end
end
