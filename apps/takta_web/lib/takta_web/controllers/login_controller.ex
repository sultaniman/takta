defmodule TaktaWeb.LoginController do
  use TaktaWeb, :controller

  def signin(conn, _params) do
    conn
    |> assign(:errors, nil)
    |> render("signin.html")
  end
end
