defmodule Takta.Accounts do
  @moduledoc false
  use Takta.Query
  alias Takta.Accounts.{User, AccountForms}

  def all, do: Repo.all(User)

  def find_by_id(nil), do: nil
  def find_by_id(user_id) do
    Repo.one(from u in User, where: u.id == ^user_id)
  end

  def find_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  def find_comments(user_id) do
    user_id
    |> preloaded(:comments)
    |> Map.get(:comments)
  end

  def find_whiteboards(user_id) do
    user_id
    |> preloaded(:whiteboards)
    |> Map.get(:whiteboards)
  end

  def create(params) do
    %User{}
    |> AccountForms.new(params)
    |> Repo.insert()
  end

  # TODO: write tests
  def activate_user(user_id) do
    user =
      user_id
      |> find_by_id()

    unless user.is_active do
      user |> update_user(%{is_active: true})
    end

    {:ok, user}
  end

  # TODO: write unit test
  def create_from_email(email) do
    params = params = %{
      email: email,
      full_name: "Awesome Stranger",
      password: UUID.uuid4(),
      is_active: false,
      is_admin: false,
      provider: "none"
    }

    %User{}
    |> AccountForms.new(params)
    |> Repo.insert()
  end

  def update_user(%User{} = user, params) do
    user
    |> AccountForms.update(params)
    |> Repo.update()
  end

  def change_password(%User{} = user, new_password) do
    user
    |> AccountForms.change_password(new_password)
    |> Repo.update()
  end

  defp preloaded(user_id, field) do
    case find_by_id(user_id) do
      nil -> {:error, :not_found}
      user -> Repo.preload(user, field)
    end
  end
end
