defmodule TaktaWeb.Plugs.Util do
  @moduledoc false
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
end
