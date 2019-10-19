defmodule Takta.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      # Set all datetimes to UTC by default
      @timestamp_opts [type: :utc_datetime]
      @primary_key {:id, :binary_id, autogenerate: true}
    end
  end
end
