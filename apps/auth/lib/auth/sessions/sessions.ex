defmodule Auth.Sessions do
  @moduledoc false
  use Auth.Query
  alias Auth.Sessions.Session

  @session_ttl Application.get_env(:auth, :session_ttl_days)

  def all, do: Repo.all(Session)

  def create(user_id) do
    {:ok, token, _claims} =
      user_id
      |> Auth.SessionToken.encode_and_sign()

    %{token: token, user_id: user_id}
    |> Session.new()
    |> Repo.insert()
  end

  def find_by_id(nil), do: nil
  def find_by_id(session_id) do
    Repo.one(
      from s in Session,
      where: s.id == ^session_id
    )
  end

  def find_by_user_id(nil), do: nil
  def find_by_user_id(user_id) do
    Repo.one(
      from s in Session,
      where: s.user_id == ^user_id
    )
  end

  def find_active(user_id) do
    valid_from =
      Timex.now("Etc/UTC")
      |> Timex.shift(days: -1 * @session_ttl)

    Repo.one(
      from s in Session,
      where: s.user_id == ^user_id and s.inserted_at > ^valid_from
    )
  end

  def is_valid?(token) do
    case Auth.SessionToken.decode_and_verify(token) do
      {:ok, _claims} -> true
      {:error, _reason} -> false
    end
  end
end
