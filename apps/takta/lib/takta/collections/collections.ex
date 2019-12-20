defmodule Takta.Collections do
  @moduledoc false
  use Takta.Query
  alias Takta.Members.Member
  alias Takta.Whiteboards.Whiteboard
  alias Takta.Collections.{Collection, CollectionForms}

  def all, do: Repo.all(Collection)

  def find_by_id(nil), do: nil
  def find_by_id(collection_id) do
    query = from c in Collection, where: c.id == ^collection_id

    query
    |> Repo.one()
    |> preload_all()
  end

  # TODO: add unit test
  def find_for_user(user_id) do
    query = from c in Collection, where: c.owner_id == ^user_id
    query
    |> Repo.all()
    |> preload_all()
  end

  # TODO: add unit test
  def add_whiteboards(collection_id, whiteboards) do
    query = from w in Whiteboard, where: w.id in ^whiteboards
    update_with = [
      collection_id: collection_id,
      updated_at: DateTime.utc_now()
    ]

    query |> Repo.update_all(set: update_with)
  end

  def create(params) do
    %Collection{}
    |> CollectionForms.new(params)
    |> Repo.insert()
  end

  def update(%Collection{} = collection, params) do
    collection
    |> CollectionForms.update(params)
    |> Repo.update()
  end

  def delete(collection_id) do
    case find_by_id(collection_id) do
      nil -> {:error, :not_found}
      annotation -> annotation |> Repo.delete()
    end
  end

  def has_owner?(collection_id, user_id) do
    query = from(
      c in Collection,
      where: c.owner_id == ^user_id and c.id == ^collection_id
    )

    query
    |> Repo.exists?()
  end

  def has_member?(nil, _user_id), do: false
  def has_member?(collection_id, user_id) do
    query = from(
      m in Member,
      where: m.member_id == ^user_id and m.collection_id == ^collection_id
    )

    query
    |> Repo.exists?()
  end

  def preload_all(q) do
    q
    |> Repo.preload(:whiteboards)
    |> Repo.preload(:members)
  end
end
