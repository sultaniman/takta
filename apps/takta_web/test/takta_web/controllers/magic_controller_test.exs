defmodule TaktaWeb.MagicControllerTest do
  use TaktaWeb.ConnCase, async: true
  alias Auth.Sessions

  describe "magic controller ✨ ::" do
    test "endpoint is accessible with valid token", %{conn:  conn} do
      {:ok, magic_token} = Sessions.create_token(UUID.uuid4())

      conn
      |> get(Routes.magic_path(conn, :magic_signin, magic_token.token))
      |> html_response(302)
    end

    test "endpoint returns HTTP 400 with invalid token", %{conn:  conn} do
      conn
      |> get(Routes.magic_path(conn, :magic_signin, UUID.uuid4()))
      |> json_response(400)
    end
  end
end
