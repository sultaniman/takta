defmodule TaktaWeb.AuthHelper do
  alias Takta.Repo
  alias Takta.Accounts
  alias Takta.Accounts.{AccountForms, User}

  def login(conn, auth, :github) do
    case signin_exists(auth.info.email, :github) do
      true -> use_existing_signin(conn)
      _ -> use_github(auth)
    end
  end

  def login(conn, auth, :google) do
    case signin_exists(auth.info.email, :google) do
      true -> use_existing_signin(conn)
      _ -> use_google(auth)
    end
  end

  defp use_github(auth) do
    authenticate(%{
      email: auth.info.email,
      full_name: auth.info.name,
      token: auth.credentials.token,
      provider: "github"
    })
  end

  defp use_google(auth) do
    authenticate(%{
      email: auth.info.email,
      full_name: auth.info.name,
      token: auth.credentials.token,
      provider: "google"
    })
  end

  defp authenticate(params) do
    %User{}
    |> AccountForms.new(params)
    |> create_or_update_user()
  end

  defp signin_exists(email, provider) do
    case Repo.get_by(User, email: email, provider: provider) do
      nil -> false
      _user -> true
    end
  end

  defp create_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        Accounts.update(user, changeset)
        {:ok, user}
    end
  end

  def use_existing_signin(conn) do
    conn
    |> Phoenix.Controller.redirect(to: '/signin')
    |> Plug.Conn.halt()
  end
end
