defmodule Auth.SessionsTest do
  @invalid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

  use Auth.DataCase
  use Auth.Query
  alias Auth.Sessions

  describe "sessions 🍪 ::" do
    test "find all_tokens works as expected" do
      assert Sessions.all_tokens() |> length() > 0
    end

    test "can create token works as expected" do
      assert {:ok, token} = Sessions.create_token(UUID.uuid4())
    end

    test "can create token fails if no input given" do
      assert {:error, _changeset} = Sessions.create_token(nil)
    end

    test "is_valid? token works as expected" do
      {:ok, token} = Sessions.create_token(UUID.uuid4())
      assert Sessions.is_valid?(token.token)
    end

    test "is_valid? token works as expected if token is invalid or malformed" do
      refute Sessions.is_valid?(@invalid_token)
    end
  end
end
