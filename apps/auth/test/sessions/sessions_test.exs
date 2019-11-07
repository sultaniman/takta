defmodule Auth.SessionsTest do
  @invalid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

  use Auth.DataCase
  use Auth.Query
  alias Auth.Sessions

  describe "sessions 🍪 ::" do
    test "find all_tokens works as expected" do
      assert Sessions.all_tokens() |> length() > 0
    end

    test "is_valid? token works as expected" do
      token = Sessions.all_tokens() |> List.first()
      assert Sessions.is_valid?(token.token)
    end

    test "is_valid? token works as expected if token is invalid or malformed" do
      refute Sessions.is_valid?(@invalid_token)
    end
  end
end
