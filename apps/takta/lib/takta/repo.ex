defmodule Takta.Repo do
  use Ecto.Repo,
    otp_app: :takta,
    adapter: Ecto.Adapters.Postgres
end
