defmodule TaktaWeb.Fixtures do
  @moduledoc false
  use Takta.Query
  alias Takta.Accounts

  def run do
    Accounts.create(%{
      email: "web@example.com",
      full_name: "Web name",
      password: "12345678",
      is_active: true,
      is_admin: false,
      provider: "github"
    })
  end
end
