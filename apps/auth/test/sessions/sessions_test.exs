defmodule Auth.SessionsTest do
  @invalid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  @expired_token "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhdXRoIiwiZXhwIjoxNTc1ODM3MTI5LCJpYXQiOjE1NzQwMjI3MjksImlzcyI6ImF1dGgiLCJqdGkiOiI5YzY2NWMzYS1hODIyLTRlNTgtOTBmMy0wYmI1ZTM2YjA0NjUiLCJuYmYiOjE1NzQwMjI3MjgsInN1YiI6IjhjZmNjMGIxLTExODEtNGI0Ni1hY2UwLTU1NTU1N2U5YWU5MCIsInR5cCI6ImFjY2VzcyJ9.vk6Lzzv60F7pzKiYyU8N4CX-G3mVtkjkseY7q6QCD5wsVRrMNM8KX2P7Cs9p3L04m34aQe9HvHnpRlcL3nyk0w"

  use Auth.DataCase
  use Auth.Query
  alias Auth.Sessions

  describe "sessions 🍪 ::" do
    test "find all works as expected" do
      assert Sessions.all() |> length() > 0
    end

    test "find by id works as expected" do
      assert {:ok, session} = Sessions.create(UUID.uuid4())
      assert (%Sessions.Session{} = _session) = Sessions.find_by_id(session.id)
    end

    test "find by user id works as expected" do
      assert {:ok, session} = Sessions.create(UUID.uuid4())
      assert (%Sessions.Session{} = _session) = Sessions.find_by_user_id(session.user_id)
    end

    test "find by user id returns nil if not found" do
      assert Sessions.find_by_user_id(UUID.uuid4()) == nil
    end

    test "can create session works as expected" do
      assert {:ok, token} = Sessions.create(UUID.uuid4())
    end

    test "can create session fails if no input given" do
      assert {:error, _changeset} = Sessions.create(nil)
    end

    test "is_valid? token works as expected" do
      {:ok, token} = Sessions.create(UUID.uuid4())
      assert Sessions.is_valid?(token.token)
    end

    test "is_valid? session works as expected if token is invalid or malformed" do
      refute Sessions.is_valid?(@invalid_token)
    end
  end
end
