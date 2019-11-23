defmodule Auth.MagicTokensTest do
  @invalid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

  use Auth.DataCase
  use Auth.Query
  alias Auth.MagicTokens

  describe "magic tokens 🎩 ::" do
    test "find all works as expected" do
      assert MagicTokens.all() |> length() > 0
    end

    test "find by user id works as expected" do
      assert {:ok, token} = MagicTokens.create_token(UUID.uuid4(), "source")
      assert (%MagicTokens.MagicToken{} = _token) = MagicTokens.find_by_user_id(token.user_id)
    end

    test "find by user id returns nil if not found" do
      assert MagicTokens.find_by_user_id(UUID.uuid4()) == nil
    end

    test "can create token works as expected" do
      assert {:ok, token} = MagicTokens.create_token(UUID.uuid4(), "social")
    end

    test "can create token fails if no input given" do
      assert {:error, _changeset} = MagicTokens.create_token(nil, "xyz")
    end

    test "is_valid? token works as expected" do
      {:ok, token} = MagicTokens.create_token(UUID.uuid4(), "email")
      assert MagicTokens.is_valid?(token.token)
    end

    test "is_valid? token works as expected if token is invalid or malformed" do
      refute MagicTokens.is_valid?(@invalid_token)
    end
  end
end
