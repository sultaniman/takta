defmodule TaktaWeb.Plugs.AuthRequired do
  @moduledoc false
  import Plug.Conn

  alias TaktaWeb.Plugs.Util

  require Logger

  @auth_required Jason.encode!(%{status: :authentication_required})

  def init(_params) do
  end

  def call(conn, _params) do
    case conn |> Util.user_authenticated?() do
      true -> conn

      false ->
        conn
        |> send_resp(401, @auth_required)
        |> halt()
    end
  end
end
