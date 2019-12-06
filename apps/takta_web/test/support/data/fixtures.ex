defmodule TaktaWeb.Fixtures do
  @moduledoc false
  use Takta.Query
  alias Takta.{Accounts, Whiteboards}

  def run do
    Accounts.create(%{
      email: "web@example.com",
      full_name: "Web name",
      password: "12345678",
      is_active: true,
      is_admin: false,
      provider: "github"
    })

    {:ok, user} = Accounts.create(%{
      email: "web-2@example.com",
      full_name: "Web 2 name",
      password: "12345678",
      is_active: true,
      is_admin: false,
      provider: "github"
    })

    Whiteboards.create(%{
      name: "WB 1 web-2",
      path: "/path/web-2.png",
      owner_id: user.id
    })
  end
end
