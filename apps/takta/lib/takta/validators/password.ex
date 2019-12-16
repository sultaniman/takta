defmodule Takta.Validators.Password do
  @moduledoc false
  import Ecto.Changeset, only: [add_error: 3]

  @doc """
  Checks if given password is valid.
  """
  def check_password(%Ecto.Changeset{} = changeset, old_password) do
    %{password_hash: hash} = changeset.data

    case Auth.password_valid?(old_password, hash) do
      true ->
        changeset

      _ ->
        changeset
        |> add_error(:password, "Password is invalid")
    end
  end
end
