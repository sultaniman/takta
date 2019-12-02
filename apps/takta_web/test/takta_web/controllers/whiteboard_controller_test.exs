defmodule TaktaWeb.WhiteboardControllerTest do
  use TaktaWeb.ConnCase, async: true
  alias Auth.{MagicTokens, Sessions}
  alias Takta.Accounts

  @valid_data "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mPUY8g9CQACZQFm8I6jQQAAAABJRU5ErkJggg=="
  @invalid_data "RG9uJ3Qgb25seSBwcmFjdGljZSB5b3VyIGFydCwgYnV0IGZvcmNlIHlvdXIgd2F5IGludG8gaXRzIHNlY3JldHMsIGZvciBpdCBhbmQga25vd2xlZGdlIGNhbiByYWlzZSBtZW4gdG8gdGhlIGRpdmluZS4="

  describe "whiteboard controller 🕹  ::" do
    test "unable to upload whiteboard unless session exists", %{conn: conn} do
      payload = %{
        filename: "payload.jpg",
        data: "data-base-64=="
      }

      error =
        conn
        |> post(Routes.whiteboard_path(conn, :create, payload))
        |> json_response(401)
        |> Map.get("error")

      assert error == "authentication_required"
    end
  end
end
