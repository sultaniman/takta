defmodule Auth.Sessions do
  @moduledoc false
  use Auth.Query

  alias Auth.Sessions.Token

  def create_token(user_id) do
    %{
      token: Auth.Guardian.encode_and_sign(user_id),
      user_id: user_id
    }
    |> Token.new()
    |> Repo.insert()
  end

  def is_valid?(token) do
    case Auth.Guardian.decode_and_verify(token) do
      {:ok, _claims} -> true
      {:error, _reason} -> false
    end
  end
end
