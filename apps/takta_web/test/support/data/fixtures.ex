defmodule TaktaWeb.Fixtures do
  @moduledoc false
  use Takta.Query
  alias Takta.{
    Accounts,
    Annotations,
    Collections,
    Comments,
    Members,
    Whiteboards
  }

  def run do
    {:ok, user1} = Accounts.create(%{
      email: "web@example.com",
      full_name: "Web name",
      password: "12345678",
      is_active: true,
      is_admin: false,
      provider: "github"
    })

    {:ok, wb1} = Whiteboards.create(%{
      name: "WB 1 web-1",
      path: "/path/web-1.png",
      owner_id: user1.id
    })

    {:ok, comment1} = Comments.create(%{
      content: "bla bla",
      author_id: user1.id,
      whiteboard_id: wb1.id
    })

    {:ok, _annotation} = Annotations.create(%{
      comment_id: comment1.id,
      whiteboard_id: wb1.id,
      coords: %{
        x: 1,
        y: 1
      }
    })

    {:ok, user2} = Accounts.create(%{
      email: "web-2@example.com",
      full_name: "Web 2 name",
      password: "12345678",
      is_active: true,
      is_admin: false,
      provider: "github"
    })

    {:ok, wb2} = Whiteboards.create(%{
      name: "WB 1 web-2",
      path: "/path/web-2.png",
      owner_id: user2.id
    })

    {:ok, comment1} = Comments.create(%{
      content: "bla bla",
      author_id: user2.id,
      whiteboard_id: wb2.id
    })

    {:ok, _annotation} = Annotations.create(%{
      comment_id: comment1.id,
      whiteboard_id: wb2.id,
      coords: %{
        x: 1,
        y: 1
      }
    })

    {:ok, collection1} = Collections.create(%{
      name: "test-collection",
      owner_id: user1.id
    })

    # Create member for the whiteboard of `user1`
    {:ok, _member} = Members.create(%{
      member_id: user2.id,
      whiteboard_id: wb1.id
    })

    {:ok, _member} = Members.create(%{
      member_id: user2.id,
      collection_id: collection1.id
    })

    Accounts.create(%{
      email: "web-admin@example.com",
      full_name: "Web admin name",
      password: "12345678",
      is_active: true,
      is_admin: true,
      provider: "github"
    })
  end
end
