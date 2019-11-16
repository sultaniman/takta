defmodule Auth.MagicTokens do
  @moduledoc false
  use Auth.Query
  alias Auth.MagicTokens.MagicToken

  def all, do: Repo.all(MagicToken)

  def create_token(user_id) do
    {:ok, token, _claims} =
      user_id
      |> Auth.Magic.encode_and_sign()

    %{token: token, user_id: user_id}
    |> MagicToken.new()
    |> Repo.insert()
  end

  def find_token(token) do
    Repo.one(
      from t in MagicToken,
      where: t.token == ^token
    )
  end

  def find_by_user_id(user_id) do
    Repo.one(
      from t in MagicToken,
      where: t.user_id == ^user_id
    )
  end

  def is_valid?(token) do
    case Auth.Magic.decode_and_verify(token) do
      {:ok, _claims} -> true
      {:error, _reason} -> false
    end
  end
end
