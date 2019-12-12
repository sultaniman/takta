defmodule TaktaWeb.InviteControllerTest do
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

  describe "invites controller 💌 ::" do
    test "whiteboard owners can invite other users", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        user2.id
        |> Whiteboards.find_for_user()
        |> List.first()

      payload = %{
        used_by_id: user1.id,
        whiteboard_id: whiteboard.id,
        can_annotate: true,
        can_comment: true
      }

      response =
        conn2
        |> post(Routes.invite_path(conn2, :create), payload)
        |> json_response(200)

      refute response |> Map.get("used")
      assert response |> Map.get("code")
      assert response |> Map.get("created_by_id") == user2.id
      assert response |> Map.get("used_by_id") == user1.id
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end

    test "owners can list their own invites", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        user2.id
        |> Whiteboards.find_for_user()
        |> List.first()

      payload = %{
        used_by_id: user1.id,
        whiteboard_id: whiteboard.id,
        can_annotate: true,
        can_comment: true
      }

      conn2
      |> post(Routes.invite_path(conn2, :create), payload)
      |> json_response(200)

      response =
        conn2
        |> get(Routes.invite_path(conn2, :list))
        |> json_response(200)

      assert %{"invites" => invites} = response
    end

    test "whiteboard owners can delete invites", %{conn2: conn2, user1: user1, user2: user2} do
      whiteboard =
        user2.id
        |> Whiteboards.find_for_user()
        |> List.first()

      payload = %{
        used_by_id: user1.id,
        whiteboard_id: whiteboard.id,
        can_annotate: true,
        can_comment: true
      }

      invite_id =
        conn2
        |> post(Routes.invite_path(conn2, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      conn2
      |> delete(Routes.invite_path(conn2, :delete, invite_id))
      |> json_response(200)
    end
  end
end
