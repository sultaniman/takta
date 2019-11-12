defmodule TaktaWeb.MagicController do
  use TaktaWeb, :controller
  alias Auth.Sessions

  def magic_signin(conn, %{"magic_token" => token}) do
    case Sessions.is_valid?(token) do
      # TODO: Create session
      true ->
        conn
        |> redirect(to: "/")
        |> halt()

      false ->
        conn
        |> put_status(400)
        |> json(%{error: :invalid_token})
    end
  end
end
