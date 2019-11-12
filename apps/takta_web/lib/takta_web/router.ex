defmodule TaktaWeb.Router do
  use TaktaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api/v1", TaktaWeb do
    pipe_through :api
  end

  scope "/", TaktaWeb do
    pipe_through :browser

    get("/", Redirect, to: "/api/v1/e")
    get("/signin", LoginController, :signin)
  end

  scope "/auth", TaktaWeb do
    pipe_through :browser

    get("/signout", AuthController, :signout)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :signin)
    get("/t/:magic_token", MagicController, :magic_signin)
  end
end
