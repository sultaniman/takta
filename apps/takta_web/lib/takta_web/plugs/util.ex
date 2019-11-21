defmodule TaktaWeb.Plugs.Util do
  @moduledoc false
  import Plug.Conn, only: [get_session: 2]

  alias Auth.Sessions
  alias Takta.Accounts

  require Logger

  def get_user_from_session(nil), do: nil
  def get_user_from_session(session) do
    case Sessions.is_valid?(session.token) do
      true -> Accounts.find_by_id(session.user_id)
      false ->
        Logger.warn("Session<id=#{session.id}> is not valid anymore...")
        nil
    end
  end

  def user_authenticated?(conn) do
    session =
      conn
      |> get_session(:session_id)
      |> Sessions.find_by_id()

    case session |> get_user_from_session() do
      nil -> false
      _user -> conn.assigns != nil and conn.assigns.authenticated
    end
  end
end
