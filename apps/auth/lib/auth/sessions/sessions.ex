defmodule Auth.Sessions do
  @moduledoc false
  alias Auth.Sessions.Token

  def create_token(user_id) do
    Token.new(%{
      token: "TODO JWT GENERATE",
      user_id: user_id
    })
  end

  def is_valid?(token) do

  end
end
