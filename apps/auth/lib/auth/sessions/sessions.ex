defmodule Auth.Sessions do
  @moduledoc false
  use Auth.Query
  alias Auth.Sessions.MagicToken

  def all_tokens, do: Repo.all(MagicToken)

  def create_token(user_id) do
    {:ok, token, _claims} =
      user_id
      |> Auth.Guardian.encode_and_sign()

    %{token: token, user_id: user_id}
    |> MagicToken.new()
    |> Repo.insert()
  end

  def is_valid?(token) do
    case Auth.Guardian.decode_and_verify(token) do
      {:ok, _claims} -> true
      {:error, _reason} -> false
    end
  end
end
