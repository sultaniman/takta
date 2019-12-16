defmodule Takta.Validators do
  @moduledoc false
  defdelegate check_password(changeset, old_password), to: Takta.Validators.Password
  defdelegate has_collection_or_whiteboard(changeset), to: Takta.Validators.MemberValidator
end
