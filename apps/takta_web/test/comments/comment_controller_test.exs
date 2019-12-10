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
  alias Takta.{Accounts, Whiteboards}

  setup do
    user1 = Accounts.find_by_email("web@example.com")
    user2 = Accounts.find_by_email("web-2@example.com")
    {:ok, magic_token1} = MagicTokens.create_token(user1.id, "github")
    {:ok, magic_token2} = MagicTokens.create_token(user2.id, "google")

    conn1 =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token1.token))

    conn2 =
      build_conn()
      |> get(Routes.magic_path(build_conn(), :magic_signin, magic_token2.token))

    {
      :ok,
      conn1: conn1, conn2: conn2, user1: user1, user2: user2
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

    test "owners can comment on their whiteboards", %{conn1: conn1, user1: user1} do
      whiteboard =
        user1.id
        |> Whiteboards.find_for_user()
        |> List.first()

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
  end
end
