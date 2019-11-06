defmodule Auth.Sessions do
  @moduledoc false
  use Auth.Query

  alias Auth.Sessions.Token
  alias Auth.Guardian

  def create_token(user_id) do
    %{
      token: Guardian.subject_for_token(user_id, nil),
      user_id: user_id
    }
    |> Token.new()
    |> Repo.insert()
  end

  def is_valid?(token) do
    Guardian.decode_and_verify(token)
  end
end
