defmodule TaktaWeb.LoginController do
  use TaktaWeb, :controller

  def signin(conn, _params) do
    render(conn, "signing.html")
  end
end
