defmodule TaktaWeb.CommentControllerTest do
  @moduledoc """
  This test suite tests commenting on
  whiteboards and how secure the api is.
  Create 2 user conns and then
  check permissions using different
  connections with attempts to
  destroy data for the other user
  """
  use TaktaWeb.ConnCase, async: true
  alias Auth.MagicTokens
  alias Takta.{Accounts, Comments, Members, Whiteboards}

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

  describe "comments controller 💬 ::" do
    test "unable to comment if not authenticated" do
      conn = build_conn()

      response =
        conn
        |> post(Routes.comment_path(conn, :create), %{content: "bla bla"})
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "unable to see comment if not authenticated" do
      conn = build_conn()

      response =
        conn
        |> get(Routes.comment_path(conn, :detail, UUID.uuid4()))
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "owners can comment on their whiteboards", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      assert whiteboard.owner_id == user1.id

      payload = %{
        content: "bla bla",
        author_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      response =
        conn1
        |> post(Routes.comment_path(conn1, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("content") == "bla bla"
      assert response |> Map.get("whiteboard_id") == whiteboard.id
    end

    test "whiteboard members are able to leave comments", %{conn2: conn2, user2: user2} do
      member =
        Members.all()
        |> Enum.filter(fn m -> m.member_id == user2.id end)
        |> List.first()

      payload = %{
        content: "huhu",
        author_id: user2.id,
        whiteboard_id: member.whiteboard_id
      }

      response =
        conn2
        |> post(Routes.comment_path(conn2, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("content") == "huhu"
      assert response |> Map.get("author_id") == user2.id
      assert response |> Map.get("whiteboard_id") == member.whiteboard_id
    end

    test "users are able to pass comments with annotation", %{conn1: conn1, user1: user1}  do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      assert whiteboard.owner_id == user1.id

      payload = %{
        content: "bobo",
        author_id: user1.id,
        whiteboard_id: whiteboard.id,
        coords: %{
          x: 8,
          y: 8
        }
      }

      response =
        conn1
        |> post(Routes.comment_path(conn1, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("content") == "bobo"
      assert response |> Map.get("whiteboard_id") == whiteboard.id
      assert response |> get_in(["annotation", "coords"]) == %{"x" => 8, "y" => 8}
    end

    test "comment with invalid annotation returns annotation error", %{conn1: conn1, user1: user1}  do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      assert whiteboard.owner_id == user1.id

      payload = %{
        content: "bobo",
        author_id: user1.id,
        whiteboard_id: whiteboard.id,
        coords: nil
      }

      response =
        conn1
        |> post(Routes.comment_path(conn1, :create), payload)
        |> json_response(200)

      assert response |> Map.get("annotation") == %{"errors" => %{"coords" => ["can't be blank"]}}
    end

    test "owners can request comment details on their whiteboards", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      assert whiteboard.owner_id == user1.id

      payload = %{
        content: "bla bla",
        author_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      comment_id =
        conn1
        |> post(Routes.comment_path(conn1, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      response =
        conn1
        |> get(Routes.comment_path(conn1, :detail, comment_id))
        |> json_response(200)

      assert get_in(response, ["id"]) == comment_id
      assert get_in(response, ["whiteboard_id"]) == whiteboard.id
      assert get_in(response, ["content"]) == "bla bla"
      assert get_in(response, ["author", "id"]) == user1.id
    end

    test "admins can request details for any comment", %{conn_admin: conn_admin} do
      comment =
        Comments.all()
        |> List.first()

      response =
        conn_admin
        |> get(Routes.comment_path(conn_admin, :detail, comment.id))
        |> json_response(200)

      assert get_in(response, ["id"]) == comment.id
      assert get_in(response, ["whiteboard_id"])
      assert get_in(response, ["content"])
      assert get_in(response, ["author", "id"]) == comment.author_id
    end

    test "whiteboard members can request details for related comment", %{conn2: conn2, user1: user1} do
      comment =
        Comments.all()
        |> Enum.filter(fn c -> c.author_id == user1.id end)
        |> List.first()

      response =
        conn2
        |> get(Routes.comment_path(conn2, :detail, comment.id))
        |> json_response(200)

      assert get_in(response, ["id"]) == comment.id
      assert get_in(response, ["whiteboard_id"]) == comment.whiteboard_id
      assert get_in(response, ["content"])
      assert get_in(response, ["author", "id"]) == comment.author_id
      assert get_in(response, ["author", "id"]) == user1.id
    end

    test "requesting unknown comment returns HTTP 404", %{conn1: conn1} do
      response =
        conn1
        |> get(Routes.comment_path(conn1, :detail, UUID.uuid4()))
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end

    test "users can update their comments", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

      assert whiteboard.owner_id == user1.id

      payload = %{
        content: "bla bla",
        author_id: user1.id,
        whiteboard_id: whiteboard.id
      }

      comment_id =
        conn1
        |> post(Routes.comment_path(conn1, :create), payload)
        |> json_response(200)
        |> Map.get("id")

      update_payload = %{
        comment: %{
          content: "toto"
        }
      }

      conn1
      |> put(Routes.comment_path(conn1, :update, comment_id), update_payload)
      |> json_response(200)
    end

    test "admins can update any comments", %{conn_admin: conn_admin} do
      comment =
        Comments.all()
        |> List.first()

      update_payload = %{
        comment: %{
          content: "toto"
        }
      }

      response =
        conn_admin
        |> put(Routes.comment_path(conn_admin, :update, comment.id), update_payload)
        |> json_response(200)

      assert response |> Map.get("content") == "toto"
      assert response |> Map.get("author_id") == comment.author_id
      assert response |> Map.get("whiteboard_id") == comment.whiteboard_id
    end

    test "users can not update comments for others", %{conn2: conn2} do
      comment =
        Comments.all()
        |> List.first()

      update_payload = %{
        comment: %{
          content: "toto"
        }
      }

      response =
        conn2
        |> put(Routes.comment_path(conn2, :update, comment.id), update_payload)
        |> json_response(403)

      assert response == %{"error" => "permission_denied"}
    end

    test "users can not update comments which do not exist and get HTTP 404", %{conn2: conn2} do
      response =
        conn2
        |> put(Routes.comment_path(conn2, :update, UUID.uuid4()), %{})
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end

    test "strangers can not update any comments" do
      comment =
        Comments.all()
        |> List.first()

      update_payload = %{
        comment: %{
          content: "toto"
        }
      }

      response =
        build_conn()
        |> put(Routes.comment_path(build_conn(), :update, comment.id), update_payload)
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "admins can delete any comment", %{conn_admin: conn_admin} do
      comment =
        Comments.all()
        |> List.first()

      response =
        conn_admin
        |> delete(Routes.comment_path(conn_admin, :delete, comment.id))
        |> json_response(200)

      assert response |> Map.get("id") == comment.id
      assert response |> Map.get("content") == comment.content
    end

    test "comment authors can delete their comments", %{conn2: conn2, user2: user2} do
      comment =
        Comments.all()
        |> Enum.filter(fn c -> c.author_id == user2.id end)
        |> List.first()

      response =
        conn2
        |> delete(Routes.comment_path(conn2, :delete, comment.id))
        |> json_response(200)

      assert response |> Map.get("id") == comment.id
      assert response |> Map.get("content") == comment.content
    end

    test "strangers can not delete comments" do
      comment =
        Comments.all()
        |> List.first()

      response =
        build_conn()
        |> delete(Routes.comment_path(build_conn(), :delete, comment.id))
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "users can not delete comments for others", %{conn2: conn2, user1: user1} do
      comment =
        Comments.all()
        |> Enum.filter(fn c -> c.author_id == user1.id end)
        |> List.first()

      response =
        conn2
        |> delete(Routes.comment_path(conn2, :delete, comment.id))
        |> json_response(403)

      assert response == %{"error" => "permission_denied"}
    end

    test "users can not delete comments which do not exist and get HTTP 404", %{conn2: conn2} do
      response =
        conn2
        |> delete(Routes.comment_path(conn2, :delete, UUID.uuid4()))
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end
  end
end
