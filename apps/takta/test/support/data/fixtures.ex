defmodule Takta.Fixtures do
  use Takta.Query
  alias Takta.{
    Accounts,
    Comments,
    Whiteboards
  }

  def run do
    {:ok, user1} = Accounts.create(%{
      email: "su@example.com",
      full_name: "Sudo name",
      password: "12345678",
      is_active: true,
      is_admin: true
    })

    Accounts.create(%{
      email: "admin@example.com",
      full_name: "Admin name",
      password: "12345678",
      is_active: true,
      is_admin: true
    })

    Accounts.create(%{
      email: "consultant1@example.com",
      full_name: "Con1 name",
      password: "12345678",
      is_active: true,
      is_admin: false
    })

    Accounts.create(%{
      email: "consultant2@example.com",
      full_name: "Con2 name",
      password: "12345678",
      is_active: true,
      is_admin: false
    })

    Whiteboards.create(%{
      name: "xyz",
      path: "my/path.png",
      owner_id: user1.id
    })

    Comments.create(%{
      content: "Comment 1",
      author_id: user1.id
    })

    Comments.create(%{
      content: "Comment 2",
      author_id: user1.id
    })

    Comments.create(%{
      content: "Comment 3",
      author_id: user1.id
    })

    Comments.create(%{
      content: "Comment 4",
      author_id: user1.id
    })
  end
end
