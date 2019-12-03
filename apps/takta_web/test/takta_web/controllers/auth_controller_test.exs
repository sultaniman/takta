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
    test "can not authenticate using social auth if request is malformed", %{conn: conn} do
      response =
        conn
        |> get(Routes.auth_path(conn, :signin, "github"), code: "bada55")
        |> html_response(200)
        |> HtmlSanitizeEx.strip_tags()

      assert response =~ "Sign using Google"
      assert response =~ "Sign using Github"
      assert response =~ "Sign using Twitter"
    end

    test "redirects to /signing page if signing with another provider exists", %{conn: conn} do
      response =
        conn
        |> get(Routes.auth_path(conn, :signin, "google"))
        |> html_response(200)
        |> HtmlSanitizeEx.strip_tags()

      assert response =~ "Sign using Google"
      assert response =~ "Sign using Github"
      assert response =~ "Sign using Twitter"
    end
  end
end
