defmodule Takta.Validators.Password do
  @moduledoc false
  import Ecto.Changeset, only: [add_error: 3]

  @doc """
  Check if new password and its confirmation both match.
  """
  def validate_password_confirmation(%Ecto.Changeset{} = changeset) do
    %{
      new_password: password,
      new_password_confirmation: confirmation
    } = changeset.changes

    case confirmation do
      ^password ->
        changeset

      _ ->
        changeset
        |> add_error(:new_password_confirmation, "Passwords do not match")
    end
  end

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
