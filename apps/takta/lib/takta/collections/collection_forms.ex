defmodule Takta.Collections.CollectionForms do
  use Takta.{Model, Query}

  alias Takta.Collections.Collection

  def base(%Collection{} = collection, attrs) do
    fields = [:name, :owner_id]

    collection
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:owner_id)
  end

  def new(%Collection{} = collection, params), do: collection |> base(params)
  def update(%Collection{} = collection, params), do: collection |> base(params)
end
