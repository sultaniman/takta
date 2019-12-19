defmodule TaktaWeb.WhiteboardControllerTest do
  @moduledoc false
  use TaktaWeb.ConnCase, async: true
  alias Auth.MagicTokens
  alias Takta.{Accounts, Whiteboards}
  alias TaktaWeb.WhiteboardService

  @valid_data "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mPUY8g9CQACZQFm8I6jQQAAAABJRU5ErkJggg=="
  @invalid_data "RG9uJ3Qgb25seSBwcmFjdGljZSB5b3VyIGFydCwgYnV0IGZvcmNlIHlvdXIgd2F5IGludG8gaXRzIHNlY3JldHMsIGZvciBpdCBhbmQga25vd2xlZGdlIGNhbiByYWlzZSBtZW4gdG8gdGhlIGRpdmluZS4="

  setup do
    user1 = Accounts.find_by_email("web@example.com")
    user2 = Accounts.find_by_email("web-2@example.com")
    admin = Accounts.find_by_email("web-admin@example.com")
    {:ok, magic_token1} = MagicTokens.create_token(user1.id, "github")
    {:ok, magic_token2} = MagicTokens.create_token(user2.id, "github")
    {:ok, magic_token_admin} = MagicTokens.create_token(admin.id, "github")

    conn1 =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token1.token))

    conn2 =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token2.token))

    conn_admin =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token_admin.token))

    {
      :ok,
      conn1: conn1, user1: user1,
      conn2: conn2, user2: user2,
      conn_admin: conn_admin, admin: admin
    }
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

    test "unable to upload whiteboard for invalid files", %{conn1: conn1} do
      payload = %{
        filename: "invalid-payload.jpg",
        data: @invalid_data
      }

      data =
        conn1
        |> post(Routes.whiteboard_path(conn1, :create), payload)
        |> json_response(400)

      assert data == %{"error" => "invalid_format"}
    end

    test "can create whiteboard with valid data and session", %{conn1: conn1, user1: user1} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      data =
        conn1
        |> post(Routes.whiteboard_path(conn1, :create), payload)
        |> json_response(200)

      assert data |> Map.has_key?("id")
      assert data |> Map.get("name") == payload.filename
      assert data |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user1.id}")
    end

    test "can delete whiteboard with valid owner and session", %{conn1: conn1} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      wid =
        conn1
        |> post(Routes.whiteboard_path(conn1, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      conn1
      |> delete(Routes.whiteboard_path(conn1, :delete, wid))
      |> json_response(200)
    end

    test "can not delete whiteboard with invalid owner and session", %{conn1: conn1} do
      # last whiteboard is not for the first user
      # check fixtures.
      wb =
        Whiteboards.all()
        |> List.last()

      response =
        conn1
        |> delete(Routes.whiteboard_path(conn1, :delete, wb.id))
        |> json_response(403)

      assert response == %{"error" => "permission_denied"}
    end

    test "returns HTTP 404 if whiteboard does not exist", %{conn1: conn1} do
      response =
        conn1
        |> delete(Routes.whiteboard_path(conn1, :delete, UUID.uuid4()))
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

    test "can list whiteboards for authenticated user", %{conn1: conn1, user1: user1} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      whiteboard_id =
        conn1
        |> post(Routes.whiteboard_path(conn1, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      response =
        conn1
        |> get(Routes.whiteboard_path(conn1, :list))
        |> json_response(200)

      assert %{"whiteboards" => wbs} = response
      assert length(wbs) == 2

      wb =
        wbs
        |> Enum.filter(fn w -> w["id"] == whiteboard_id end)
        |> List.first()

      assert wb |> Map.has_key?("id")
      assert wb |> Map.get("name") == payload.filename
      assert wb |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user1.id}")
    end

    test "can get whiteboard details for authenticated user", %{conn1: conn1, user1: user1} do
      payload = %{
        filename: "valid-whiteboard.jpg",
        data: @valid_data
      }

      wid =
        conn1
        |> post(Routes.whiteboard_path(conn1, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      response =
        conn1
        |> get(Routes.whiteboard_path(conn1, :detail, wid))
        |> json_response(200)

      assert %{"whiteboard" => wb} = response
      assert wb |> Map.has_key?("id")
      assert wb |> Map.get("name") == payload.filename
      assert wb |> Map.get("path") |> String.starts_with?("takta-whiteboards/#{user1.id}")
      assert wb |> Map.get("comments") == []
      assert wb |> Map.get("annotations") == []
    end

    test "can get whiteboard comments and annotations for authenticated user", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      response =
        conn1
        |> get(Routes.whiteboard_path(conn1, :detail, whiteboard.id))
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

      assert comment |> Map.take(["content", "whiteboard_id"]) == %{
        "content" => "bla bla",
        "whiteboard_id" => whiteboard.id
      }

      assert annotation |> Map.take(["coords", "comment_id", "whiteboard_id"]) == %{
        "coords" => %{"x" => 1, "y" => 1},
        "comment_id" => comment |> Map.get("id"),
        "whiteboard_id" => whiteboard.id
      }
    end

    test "can comment on whiteboard if user has permissions", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      response =
        conn1
        |> post(Routes.whiteboard_path(conn1, :comment, whiteboard.id), %{content: "toto"})
        |> json_response(200)

      refute response |> Map.has_key?("annotation")
      assert response |> Map.get("content") == "toto"
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end

    test "commenting on whiteboard also validates input", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      response =
        conn1
        |> post(Routes.whiteboard_path(conn1, :comment, whiteboard.id), %{content: nil})
        |> json_response(400)

      assert response == %{
        "details" => %{"content" => ["can't be blank"]},
        "error" => "bad_request"
      }
    end

    test "admins can comment on any whiteboard", %{conn_admin: conn_admin} do
      whiteboard =
        Whiteboards.all()
        |> List.first()

      response =
        conn_admin
        |> post(Routes.whiteboard_path(conn_admin, :comment, whiteboard.id), %{content: "toto"})
        |> json_response(200)

      refute response |> Map.has_key?("annotation")
      assert response |> Map.get("content") == "toto"
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end

    test "strangers are not allowed to comment on any whiteboard" do
      whiteboard =
        Whiteboards.all()
        |> List.first()

      response =
        build_conn()
        |> post(Routes.whiteboard_path(build_conn(), :comment, whiteboard.id), %{content: "toto"})
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "whiteboard owners can add members", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        Whiteboards.find_for_user(user2.id)
        |> List.first()

      payload = %{
        member: %{
          can_annotate: true,
          can_comment: true,
          member_id: user1.id
        }
      }

      response =
        conn2
        |> post(Routes.whiteboard_path(conn2, :create_member, whiteboard.id), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("can_annotate") == true
      assert response |> Map.get("can_comment") == true
      assert response |> Map.get("member_id") == user1.id
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end
  end
end
