defmodule TaktaWeb.Router do
  use TaktaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TaktaWeb do
    pipe_through :api
  end
end
