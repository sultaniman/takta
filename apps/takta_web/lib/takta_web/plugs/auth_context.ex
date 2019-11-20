defmodule TaktaWeb.Plugs.AuthContext do
  @moduledoc false
  import Plug.Conn

  alias Auth.Sessions
  alias Takta.Accounts

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
    7. Else set nil values to request.
  """
  def call(conn, _params) do
    session_id = conn |> get_session(:session_id)

    case session_id |> Sessions.find_by_id() |> get_user_from_session() do
      nil -> conn |> no_user()
      user ->
        conn
        |> assign(:user, user)
        |> assign(:authenticated, true)
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

  defp no_user(conn) do
    conn
    |> assign(:user, nil)
    |> assign(:authenticated, false)
  end
end
