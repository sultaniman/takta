defmodule Takta.Invites do
  @moduledoc false
  use Takta.Query
  alias Takta.Invites.{Invite, InviteForms}

  def all, do: Repo.all(Invite)

  def find_by_id(nil), do: nil
  def find_by_id(id) do
    Repo.one(from i in Invite, where: i.id == ^id)
  end

  def find_by_code(nil), do: nil
  def find_by_code(code) do
    query = from(i in Invite, where: i.code == ^code)
    query
    |> Repo.one()
    |> preload_all()
  end

  def create(params) do
    %Invite{}
    |> InviteForms.new(params)
    |> Repo.insert()
  end

  def update(%Invite{} = invite, params) do
    invite
    |> InviteForms.update(params)
    |> Repo.update()
  end

  def delete(id) do
    case find_by_id(id) do
      nil -> {:error, :not_found}
      invite -> Repo.delete(invite)
    end
  end

  def find_for_user(user_id) do
    Repo.all(from i in Invite, where: i.created_by_id == ^user_id)
  end

  def preload_all(invite) do
    invite
    |> Repo.preload(:member)
    |> Repo.preload(:created_by)
  end

  @valid_until 3600
  def is_valid(id) do
    case find_by_id(id) do
      nil -> false
      invite ->
        diff = DateTime.diff(invite.inserted_at, DateTime.utc_now())
        abs(diff) < @valid_until
    end
  end
end
