defmodule TaktaWeb.WhiteboardControllerTest do
  use TaktaWeb.ConnCase, async: true
  alias Auth.MagicTokens
  alias Takta.{Accounts, Whiteboards}
  alias TaktaWeb.Whiteboards.WhiteboardService

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

    test "can delete whiteboard with valid owner and session", %{conn: conn} do
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

    test "can not delete whiteboard with invalid owner and session", %{conn: conn} do
      # last whiteboard is not for the first user
      # check fixtures.
      wb =
        Whiteboards.all()
        |> List.last()

      response =
        conn
        |> delete(Routes.whiteboard_path(conn, :delete, wb.id))
        |> json_response(403)

      assert response == %{"error" => "permission_denied"}
    end

    test "returns HTTP 404 if whiteboard does not exist", %{conn: conn} do
      response =
        conn
        |> delete(Routes.whiteboard_path(conn, :delete, UUID.uuid4()))
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end

    test "returns HTTP 404 if user does not exist" do
      # We are testing this case indirectly because auth required
      # plug is not going to allow unknown user ids to set :user
      # in conn assigns dictionary.
      wb =
        Whiteboards.all()
        |> List.first()

      result = WhiteboardService.delete_for_user(wb.id, UUID.uuid4())
      assert result == {404, %{error: :not_found}}
    end

    test "can list whiteboards for authenticated user", %{conn: conn, user: user} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      conn
      |> post(Routes.whiteboard_path(conn, :create), payload)
      |> json_response(200)

      response =
        conn
        |> get(Routes.whiteboard_path(conn, :list))
        |> json_response(200)

      assert %{"whiteboards" => wbs} = response
      assert length(wbs) == 2

      wb = wbs |> List.last()
      assert wb |> Map.has_key?("id")
      assert wb |> Map.get("name") == payload.filename
      assert wb |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user.id}")
    end

    test "can get whiteboard details for authenticated user", %{conn: conn, user: user} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      wid =
        conn
        |> post(Routes.whiteboard_path(conn, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      response =
        conn
        |> get(Routes.whiteboard_path(conn, :detail, wid))
        |> json_response(200)

      assert %{"whiteboard" => wb} = response
      assert wb |> Map.has_key?("id")
      assert wb |> Map.get("name") == payload.filename
      assert wb |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user.id}")
      assert wb |> Map.get("comments") == []
      assert wb |> Map.get("annotations") == []
    end

    test "can get whiteboard comments and annotations for authenticated user", %{conn: conn, user: user} do
      whiteboard =
        user.id
        |> Whiteboards.find_for_user()
        |> List.first()

      response =
        conn
        |> get(Routes.whiteboard_path(conn, :detail, whiteboard.id))
        |> json_response(200)

      assert %{"whiteboard" => wb} = response

      comment =
        wb
        |> Map.get("comments")
        |> Enum.at(0)

      annotation =
        wb
        |> Map.get("annotations")
        |> Enum.at(0)

      assert comment
      assert comment |> Map.get("content") == "bla bla"
      assert comment |> Map.get("whiteboard_id") == whiteboard.id

      assert annotation
      assert annotation |> Map.get("coords") == %{"x" => 1, "y" => 1}
      assert annotation |> Map.get("comment_id") == comment |> Map.get("id")
      assert annotation |> Map.get("whiteboard_id") == whiteboard.id
    end
  end
end
