defmodule Takta.Collections.CollectionMapper do
  @moduledoc false
  alias Takta.Collections.Collection

  def to_json_basic(%Collection{} = collection) do
    %{
      id: collection.id,
      name: collection.name,
      owner_id: collection.owner_id
    }
  end
end
