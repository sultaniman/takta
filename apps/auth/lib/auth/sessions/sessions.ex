defmodule Auth.Sessions do
  @moduledoc false
  use Auth.Query
  alias Auth.Sessions.Session

  def all, do: Repo.all(Session)

  def create(user_id) do
    {:ok, token, _claims} =
      user_id
      |> Auth.SessionToken.encode_and_sign()

    %{token: token, user_id: user_id}
    |> Session.new()
    |> Repo.insert()
  end

  def find_by_user_id(user_id) do
    Repo.one(
      from t in Session,
      where: t.user_id == ^user_id
    )
  end

  def is_valid?(token) do
    case Auth.SessionToken.decode_and_verify(token) do
      {:ok, _claims} -> true
      {:error, _reason} -> false
    end
  end
end
