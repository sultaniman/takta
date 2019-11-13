defmodule Auth.SessionToken do
  @moduledoc false
  use Guardian, otp_app: :auth

  def subject_for_token(user_id, _claims) do
    {:ok, to_string(user_id)}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    {:ok, user_id}
  end
end
