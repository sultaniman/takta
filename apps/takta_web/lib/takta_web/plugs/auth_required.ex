defmodule TaktaWeb.Plugs.AuthRequired do
  import Plug.Conn

  alias Auth.Sessions
  alias Takta.Accounts

  require Logger

  @auth_required Jason.encode!(%{status: :authentication_required})

  def init(_params) do
  end

  def call(conn, _params) do
    case conn |> user_authenticated?() do
      true -> conn

      false ->
        conn
        |> send_resp(401, @auth_required)
        |> halt()
    end
  end

  defp user_authenticated?(conn) do
    session_id = conn |> get_session(:session_id)
    if session_id and conn.assigns.authenticated? do
      true
    else
      false
    end
  end
end
