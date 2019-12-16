defmodule Takta.Collections do
  @moduledoc false
  use Takta.Query
  alias Takta.Collections.{Collection, CollectionForms}

  def all, do: Repo.all(Collection)

  def find_by_id(collection_id) do
    Repo.one(from c in Collection, where: c.id == ^collection_id)
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
end
