defmodule Auth.Query do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Auth.Repo
    end
  end
end
