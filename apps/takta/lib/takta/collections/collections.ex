defmodule Takta.Collections do
  @moduledoc false
  use Takta.Query
  alias Takta.Collections.{Collection, CollectionForms}

  def all, do: Repo.all(Collection)

  def find_by_id(collection_id) do
    query = from c in Collection, where: c.id == ^collection_id

    query
    |> Repo.one()
    |> preload_all()
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

  def preload_all(q) do
    q
    |> Repo.preload(:whiteboards)
    |> Repo.preload(:members)
  end
end
