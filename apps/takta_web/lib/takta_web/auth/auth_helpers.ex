defmodule TaktaWeb.AuthHelper do
  use Takta.Query

  alias Auth.MagicTokens
  alias Takta.Accounts
  alias Takta.Accounts.{AccountForms, User}
  alias TaktaWeb.Router

  def login(conn, auth, :github) do
    case signin_exists(auth.info.email, "github") do
      true -> use_existing_signin(conn)
      _ -> use_github(auth)
    end
  end

  def login(conn, auth, :google) do
    case signin_exists(auth.info.email, "google") do
      true -> use_existing_signin(conn)
      _ -> use_google(auth)
    end
  end

  def use_existing_signin(conn) do
    conn
    |> Phoenix.Controller.redirect(to: "/signin")
    |> Plug.Conn.halt()
  end

  @doc """
  Creates `MagicToken` and returns link to signing using it.
  """
  def get_magic_link(conn, user_id, source) do
    {:ok, magic_token} = MagicTokens.create_token(user_id, source)

    conn
    |> Router.Helpers.magic_path(:magic_signin, magic_token.token)
  end

  defp use_github(auth) do
    authenticate(%{
      email: auth.info.email,
      full_name: auth.info.name,
      token: auth.credentials.token,
      provider: "github",
      password: UUID.uuid4()
    })
  end

  defp use_google(auth) do
    authenticate(%{
      email: auth.info.email,
      full_name: auth.info.name,
      token: auth.credentials.token,
      provider: "google",
      password: UUID.uuid4()
    })
  end

  defp authenticate(params) do
    %User{}
    |> AccountForms.new(params)
    |> create_or_update_user()
  end

  defp signin_exists(email, provider) do
    query = from u in User, where: u.email == ^email and u.provider != ^provider
    case Repo.one(query) do
      nil -> false
      _user -> true
    end
  end

  defp create_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        Accounts.update(user, changeset.changes)
        {:ok, user}
    end
  end
end
