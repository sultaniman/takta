defmodule Takta.Validators do
  @moduledoc false
  defdelegate check_password(changeset, old_password), to: Takta.Validators.Password
end
