defmodule TaktaWeb.AuthControllerTest do
  @moduledoc false
  use TaktaWeb.ConnCase, async: true
  alias Takta.Accounts

  setup do
    user = Accounts.find_by_email("web@example.com")
    auth_info = %{
      info: %{
        email: user.email
      }
    }

    conn =
      build_conn()
      |> assign(:ueberauth_auth, auth_info)

    {:ok, conn: conn, user: user}
  end

  describe "auth controller 🍻 ::" do
    test "can authenticate using social auth provider", %{conn: conn} do
      response =
        conn
        |> get(Routes.auth_path(conn, :signin, "github"))
        |> html_response(302)

      text = response |> HtmlSanitizeEx.strip_tags()

      assert text =~ "You are being redirected"
      assert response =~ "<a href=\"/\""
    end
  end
end
