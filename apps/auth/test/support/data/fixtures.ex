defmodule Auth.Fixtures do
  alias Auth.{MagicTokens, Sessions}

  def run do
    MagicTokens.create_token(UUID.uuid4())
    MagicTokens.create_token(UUID.uuid4())
    MagicTokens.create_token(UUID.uuid4())
    MagicTokens.create_token(UUID.uuid4())

    Sessions.create(UUID.uuid4())
  end
end
