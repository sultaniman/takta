defmodule TaktaWeb.WhiteboardControllerTest do
  use TaktaWeb.ConnCase, async: true
  alias Auth.MagicTokens
  alias Takta.Accounts

  @valid_data "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mPUY8g9CQACZQFm8I6jQQAAAABJRU5ErkJggg=="
  @invalid_data "RG9uJ3Qgb25seSBwcmFjdGljZSB5b3VyIGFydCwgYnV0IGZvcmNlIHlvdXIgd2F5IGludG8gaXRzIHNlY3JldHMsIGZvciBpdCBhbmQga25vd2xlZGdlIGNhbiByYWlzZSBtZW4gdG8gdGhlIGRpdmluZS4="

  setup do
    user = Accounts.find_by_email("web@example.com")
    {:ok, magic_token} = MagicTokens.create_token(user.id, "github")

    conn =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token.token))

    {:ok, conn: conn, user: user}
  end

  describe "whiteboard controller 🕹  ::" do
    test "unable to upload whiteboard unless session exists" do
      payload = %{
        filename: "payload.jpg",
        data: @invalid_data
      }

      error =
        build_conn()
        |> post(Routes.whiteboard_path(build_conn(), :create), payload)
        |> json_response(401)
        |> Map.get("error")

      assert error == "authentication_required"
    end

    test "unable to upload whiteboard for invalid files", %{conn: conn} do
      payload = %{
        filename: "invalid-payload.jpg",
        data: @invalid_data
      }

      data =
        conn
        |> post(Routes.whiteboard_path(conn, :create), payload)
        |> json_response(400)

      assert data == %{"error" => "invalid_format"}
    end

    test "can create whiteboard with valid data and session", %{conn: conn, user: user} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      data =
        conn
        |> post(Routes.whiteboard_path(conn, :create), payload)
        |> json_response(200)

      assert data |> Map.has_key?("id")
      assert data |> Map.get("name") == payload.filename
      assert data |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user.id}")
    end

    test "can delete whiteboard with valid owner and session", %{conn: conn, user: user} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      wid =
        conn
        |> post(Routes.whiteboard_path(conn, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      conn
        |> delete(Routes.whiteboard_path(conn, :delete, wid))
        |> json_response(200)
    end
  end
end
