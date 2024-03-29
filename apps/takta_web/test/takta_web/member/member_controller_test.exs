defmodule TaktaWeb.MemberControllerTest do
  @moduledoc false
  use TaktaWeb.ConnCase, async: true
  alias Auth.MagicTokens
  alias Takta.{Accounts, Whiteboards}

  setup do
    user1 = Accounts.find_by_email("web@example.com")
    user2 = Accounts.find_by_email("web-2@example.com")
    admin = Accounts.find_by_email("web-admin@example.com")
    {:ok, magic_token1} = MagicTokens.create_token(user1.id, "github")
    {:ok, magic_token2} = MagicTokens.create_token(user2.id, "google")
    {:ok, magic_token_admin} = MagicTokens.create_token(admin.id, "google")

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
      conn1: conn1,
      conn2: conn2,
      conn_admin: conn_admin,
      user1: user1,
      user2: user2,
      admin: admin
    }
  end

  describe "members controller 🎭 ::" do
    test "whiteboard owners can add members", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        Whiteboards.all()
        |> Enum.filter(fn w -> w.owner_id == user2.id end)
        |> List.first()

      payload = %{
        can_annotate: true,
        can_comment: true,
        member_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      response =
        conn2
        |> post(Routes.member_path(conn2, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("can_annotate") == true
      assert response |> Map.get("can_comment") == true
      assert response |> Map.get("member_id") == user1.id
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end

    test "whiteboard owners can remove members", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        Whiteboards.find_for_user(user2.id)
        |> List.first()

      payload = %{
        can_annotate: true,
        can_comment: true,
        member_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      response =
        conn2
        |> post(Routes.member_path(conn2, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("can_annotate") == true
      assert response |> Map.get("can_comment") == true
      assert response |> Map.get("member_id") == user1.id
      assert response |> Map.get("whiteboard_id") == whiteboard.id

      member_id = response |> Map.get("id")
      conn2
      |> delete(Routes.member_path(conn2, :delete, member_id))
      |> json_response(200)
    end

    test "whiteboard owners can update permissions for members", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        Whiteboards.find_for_user(user2.id)
        |> List.first()

      payload = %{
        can_annotate: true,
        can_comment: true,
        member_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      response =
        conn2
        |> post(Routes.member_path(conn2, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      member_id = response |> Map.get("id")

      payload = %{
        permissions: %{
          can_annotate: false,
          can_comment: true
        }
      }

      response =
        conn2
        |> put(Routes.member_path(conn2, :update, member_id), payload)
        |> json_response(200)

      assert response |> Map.get("can_annotate") == false
      assert response |> Map.get("can_comment") == true
    end

    test "whiteboard owners can get details for any member", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        Whiteboards.find_for_user(user2.id)
        |> List.first()

      payload = %{
        can_annotate: true,
        can_comment: true,
        member_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      response =
        conn2
        |> post(Routes.member_path(conn2, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("can_annotate") == true
      assert response |> Map.get("can_comment") == true
      assert response |> Map.get("member_id") == user1.id
      assert response |> Map.get("whiteboard_id") == whiteboard.id

      member_id = response |> Map.get("id")
      conn2
      |> get(Routes.member_path(conn2, :detail, member_id))
      |> json_response(200)
    end

    test "deleting unknown member return HTTP 404", %{conn2: conn2} do
      response =
        conn2
        |> delete(Routes.member_path(conn2, :delete, UUID.uuid4()))
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end
  end
end
