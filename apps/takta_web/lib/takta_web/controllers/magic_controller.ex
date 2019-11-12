defmodule TaktaWeb.MagicController do
  use TaktaWeb, :controller

  def magic_signin(conn, %{:magic_token => token}) do
    conn |> json(%{message: :ok, token: token})
  end
end
