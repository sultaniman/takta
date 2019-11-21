defmodule TaktaWeb.MagicController do
  @moduledoc false
  use TaktaWeb, :controller
  import TaktaWeb.AuthUtil, only: [deny: 1, maybe_authenticate: 2]

  alias Auth.MagicTokens

  @doc """
  Signin with `MagicToken` and exchange it to
  new session which is assigned to request.
  """
  def magic_signin(conn, %{"magic_token" => token}) do
    case MagicTokens.find_token(token) do
      nil -> conn |> deny()
      magic_token -> conn |> maybe_authenticate(magic_token)
    end
  end
end
