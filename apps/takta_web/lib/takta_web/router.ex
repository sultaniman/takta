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

    # Whiteboard resources
    post    "/whiteboards",             WhiteboardController, :create
    get     "/whiteboards",             WhiteboardController, :list
    get     "/whiteboards/:id",         WhiteboardController, :detail
    delete  "/whiteboards/:id",         WhiteboardController, :delete
    post    "/whiteboards/:id/comment", WhiteboardController, :comment

    # Comments resource
    post    "/comments",      CommentController, :create
    get     "/comments/:id",  CommentController, :detail
    put     "/comments/:id",  CommentController, :update
    delete  "/comments/:id",  CommentController, :delete

    # Members resource
    post    "/members",      MemberController, :create
    # get     "/members/:id",  MemberController, :detail
    # put     "/members/:id",  MemberController, :update
    # delete  "/members/:id",  MemberController, :delete
  end

  # General purpose endpoints
  scope "/", TaktaWeb do
    pipe_through :browser

    get("/", Redirect, to: "/api/v1/e")
    get("/signin", LoginController, :signin)
  end

  # TODO: render session with key=takta and value=signed_session
  scope "/api/v1/e", TaktaWeb do
    pipe_through :api
  end

  # Members resource
  scope "/members", TaktaWeb do
    pipe_through :api
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
