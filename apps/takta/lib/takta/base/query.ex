defmodule Takta.Query do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Takta.Repo
    end
  end
end
