defmodule Auth.SessionsTest do
  # @invalid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  use Auth.DataCase
  use Auth.Query
  alias Auth.Sessions

  describe "sessions 🍪 ::" do
    test "find all_tokens works as expected" do
      assert Sessions.all_tokens() |> length() > 0
    end
  end
end
