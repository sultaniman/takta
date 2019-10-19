defmodule Takta.Validators do
  @moduledoc false
  defdelegate validate_password_confirmation(changeset), to: Takta.Validators.Password
  defdelegate check_password(changeset, old_password), to: Takta.Validators.Password
end
