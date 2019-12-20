defmodule TaktaWeb.SocialAuthHelpers do
  use Takta.Query

  import Plug.Conn, only: [assign: 3]
  import Phoenix.Controller, only: [put_flash: 3, put_view: 2, redirect: 2, render: 2]

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

  def authenticate(conn, auth, provider) do
    case login(conn, auth, provider) do
      {:ok, user} ->
        conn |> redirect(to: get_magic_link(conn, user.id, provider))

      {:error, reason} ->
        conn
        |> show_login(reason, "Something went wrong during signin.")

      conn ->
        conn
        |> put_flash(:error, "You have already signed in with other platform.")
    end
  end

  def show_login(conn, errors, message) do
    conn
    |> assign(:errors, errors)
    |> put_flash(:error, message)
    |> put_view(TaktaWeb.LoginView)
    |> render("signin.html")
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
        Accounts.update_user(user, changeset.changes)
        {:ok, user}
    end
  end
end
