defmodule TaktaWeb.Plugs.AuthRequired do
  @moduledoc false
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
    case session_id |> Sessions.find_by_id() |> get_user_from_session() do
      nil -> false
      _user -> conn.assigns != nil and conn.assigns.authenticated
    end
  end

  defp get_user_from_session(nil), do: nil
  defp get_user_from_session(session) do
    case Sessions.is_valid?(session.token) do
      true -> Accounts.find_by_id(session.user_id)
      false ->
        Logger.warn("Session<id=#{session.id}> is not valid anymore...")
        nil
    end
  end
end
