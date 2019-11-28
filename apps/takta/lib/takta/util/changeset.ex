defmodule Takta.Util.Changeset do
  @moduledoc false
  alias Ecto.Changeset

  @doc """
  Transform changeset errors to map so then
  to return as response to clients.
  """
  def errors_to_json(%Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
