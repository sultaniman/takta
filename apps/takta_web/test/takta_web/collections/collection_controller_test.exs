defmodule TaktaWeb.CollectionControllerTest do
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

  describe "collections controller 🗃 ::" do
    test "unable to create collection if not authenticated" do
      conn = build_conn()

      response =
        conn
        |> post(Routes.collection_path(conn, :create), %{name: "bla bla"})
        |> json_response(401)

      assert response == %{"error" => "authentication_required"}
    end

    test "can create collection with proper session", %{conn1: conn1, user1: user1} do
      payload = %{
        name: "toto"
      }

      response =
        conn1
        |> post(Routes.collection_path(conn1, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("name") == "toto"
      assert response |> Map.get("owner_id") == user1.id
    end

    test "create endpoint accepts only collection name", %{conn1: conn1, user1: user1} do
      payload = %{
        name: "toto",
        some_random_field: "bla bla",
        uid: UUID.uuid4()
      }

      response =
        conn1
        |> post(Routes.collection_path(conn1, :create), payload)
        |> json_response(200)

      assert response |> Map.has_key?("id")
      assert response |> Map.get("name") == "toto"
      assert response |> Map.get("owner_id") == user1.id
    end

    test "it validates collection name", %{conn1: conn1} do
      response =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "y"})
        |> json_response(400)

      assert response == %{
        "error" => "bad_request",
        "details" => %{"name" => ["should be at least 2 character(s)"]}
      }

      response =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: nil})
        |> json_response(400)

      assert response == %{
        "error" => "bad_request",
        "details" => %{"name" => ["can't be blank"]}
      }
    end

    test "owners can delete collections", %{conn1: conn1} do
      payload = %{
        name: "toto"
      }

      collection =
        conn1
        |> post(Routes.collection_path(conn1, :create), payload)
        |> json_response(200)

      response =
        conn1
        |> delete(Routes.collection_path(conn1, :delete, collection["id"]))
        |> json_response(200)

      assert response == collection
    end

    test "owners can see their collections", %{conn1: conn1} do
      created_collection =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "toto"})
        |> json_response(200)

      response =
        conn1
        |> get(Routes.collection_path(conn1, :list))
        |> json_response(200)

      assert %{"collections" => collections} = response
      collection =
        collections
        |> Enum.at(0)

      assert created_collection == collection
    end

    # TODO: write unit test
    test "members can see their collections", %{conn1: _conn1} do
    end

    test "owners can see collection details", %{conn1: conn1} do
      collection =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "toto"})
        |> json_response(200)

      response =
        conn1
        |> get(Routes.collection_path(conn1, :detail, collection["id"]))
        |> json_response(200)

      assert response |> Enum.at(0) == collection
    end

    # TODO: write unit test
    test "members can see collection details", %{conn1: _conn1} do
    end

    test "owners can update collections", %{conn1: conn1} do
      collection =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "toto"})
        |> json_response(200)

      response =
        conn1
        |> put(Routes.collection_path(conn1, :delete, collection["id"]), %{name: "bobo"})
        |> json_response(200)

      assert response |> Map.get("name") == "bobo"
    end

    test "users get not found HTTP 404 if collection not found", %{conn1: conn1} do
      response =
        conn1
        |> get(Routes.collection_path(conn1, :detail, UUID.uuid4()))
        |> json_response(404)

      assert response == %{"error" => "not_found"}
    end

    test "owners can get whiteboards for collection", %{conn1: conn1, user1: user1} do
      collection =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "toto"})
        |> json_response(200)

      {:ok, whiteboard} = Whiteboards.create(%{
        name: "test-wb",
        path: "path/to/file.png",
        owner_id: user1.id,
        collection_id: collection["id"]
      })

      response =
        conn1
        |> get(Routes.collection_path(conn1, :get_whiteboards, collection["id"]))
        |> json_response(200)

      assert %{"whiteboards" => whiteboards} = response
      first = whiteboards |> Enum.at(0)
      assert first |> Map.get("id") == whiteboard.id
      assert first |> Map.get("name") == whiteboard.name
      assert first |> Map.get("path") == whiteboard.path
    end

    test "owners can add whiteboards to collection", %{conn1: conn1, user1: user1} do
      collection_id =
        conn1
        |> post(Routes.collection_path(conn1, :create), %{name: "toto"})
        |> json_response(200)
        |> Map.get("id")

      {:ok, whiteboard} = Whiteboards.create(%{
        name: "test-wb",
        path: "path/to/file.png",
        owner_id: user1.id
      })

      payload = %{
        whiteboards: [whiteboard.id]
      }

      conn1
      |> post(Routes.collection_path(conn1, :add_whiteboards, collection_id), payload)
      |> json_response(200)

      response =
        conn1
        |> get(Routes.collection_path(conn1, :get_whiteboards, collection_id))
        |> json_response(200)

      assert %{"whiteboards" => whiteboards} = response
      first = whiteboards |> Enum.at(0)
      assert first |> Map.get("id") == whiteboard.id
      assert first |> Map.get("name") == whiteboard.name
      assert first |> Map.get("path") == whiteboard.path
    end
  end
end
