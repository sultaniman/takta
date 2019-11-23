defmodule Auth.Fixtures do
  alias Auth.{MagicTokens, Sessions}

  def run do
    MagicTokens.create_token(UUID.uuid4(), "email")
    MagicTokens.create_token(UUID.uuid4(), "social")
    MagicTokens.create_token(UUID.uuid4(), "signin")
    MagicTokens.create_token(UUID.uuid4(), "email")

    Sessions.create(UUID.uuid4())
  end
end
