defmodule Takta.Accounts.AccountForms do
  use Takta.Model
  use Takta.Query

  alias Takta.Accounts.User
  alias Takta.Validators

  @default_password_length 6
  @password_min_length Application.get_env(
    :takta,
    :password_min_length,
    @default_password_length
  )

  def base(%User{} = user, attrs) do
    fields = ~w(email full_name is_active is_admin provider)a
    required_fields = ~w(email full_name)a

    user
    |> cast(attrs, fields)
    |> validate_required(required_fields)
    |> validate_format(:email, ~r/.*@.*/)
    |> unique_constraint(:email)
  end

  def new(%User{} = user, params) do
    user
    |> base(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: @password_min_length)
    |> put_password_hash()
  end

  def update(%User{} = user, params), do: user |> base(params)

  def change_password(user, params) do
    fields = ~w(password password_hash new_password new_password_confirmation)a

    user
    |> cast(params, fields)
    |> validate_required(fields)
    |> Validators.check_password(params[:password])
    |> Validators.validate_password_confirmation()
    |> validate_length(:new_password, min: @password_min_length)
    |> update_password()
  end

  defp update_password(changes) do
    case changes.valid? do
      true ->
        changes
        |> put_change(:password, changes.changes[:new_password])
        |> put_password_hash()

      _ ->
        changes
    end
  end

  defp put_password_hash(%{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, Auth.hash_password(password))
  end

  defp put_password_hash(%{changes: %{}} = changeset), do: changeset
end
