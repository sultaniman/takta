defmodule Auth.Fixtures do
  alias Auth.Sessions

  def run do
    Sessions.create_token(UUID.uuid4())
    Sessions.create_token(UUID.uuid4())
    Sessions.create_token(UUID.uuid4())
    Sessions.create_token(UUID.uuid4())
  end
end
