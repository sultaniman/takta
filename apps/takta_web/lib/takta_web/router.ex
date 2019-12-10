defmodule TaktaWeb.Router do
  use TaktaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug TaktaWeb.Plugs.AuthContext
    plug TaktaWeb.Plugs.AuthRequired
  end

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TaktaWeb.Plugs.AuthContext
  end

  scope "/api/v1", TaktaWeb do
    pipe_through :api
  end

  # General purpose endpoints
  scope "/", TaktaWeb do
    pipe_through :browser

    get("/", Redirect, to: "/api/v1/e")
    get("/signin", LoginController, :signin)
  end

  # Whiteboard resources
  scope "/api/v1/w", TaktaWeb do
    pipe_through :api

    get("/", WhiteboardController, :list)
    post("/", WhiteboardController, :create)
    get("/:id", WhiteboardController, :detail)
    delete("/:id", WhiteboardController, :delete)
  end

  # Members resource
  scope "/members", TaktaWeb do
    pipe_through :api
  end

  # Comments resource
  scope "/api/v1/c", TaktaWeb do
    pipe_through :api

    get("/:id", CommentController, :detail)
    post("/", CommentController, :create)
    put("/:id", CommentController, :update)
    delete("/:id", CommentController, :delete)
  end

  # Annotations resource
  scope "/annotations", TaktaWeb do
    pipe_through :api
  end

  # Invites resource
  scope "/invites", TaktaWeb do
    pipe_through :api
  end

  # Accounts resource
  scope "/accounts", TaktaWeb do
    pipe_through :api
  end

  # Session & authentication
  scope "/auth", TaktaWeb do
    pipe_through :browser

    get("/signout", AuthController, :signout)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :signin)

    # Login w/ JWT token
    get("/t/:magic_token", MagicController, :magic_signin)
  end
end
