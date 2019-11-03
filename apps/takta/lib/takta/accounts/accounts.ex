defmodule Takta.Accounts do
  @moduledoc false
  use Takta.Query
  alias Takta.Accounts.{User, AccountForms}

  def all, do: Repo.all(User)

  def find_by_id(user_id) do
    Repo.one(from u in User, where: u.id == ^user_id)
  end

  def find_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  def find_comments(user_id) do
    case find_by_id(user_id) do
      nil -> {:error, :not_found}
      user -> Repo.preload(user, :comments).comments
    end
  end

  def create(params) do
    %User{}
    |> AccountForms.new(params)
    |> Repo.insert()
  end

  def update(%User{} = user, params) do
    user
    |> AccountForms.update(params)
    |> Repo.update()
  end

  def change_password(%User{} = user, new_password) do
    user
    |> AccountForms.change_password(new_password)
    |> Repo.update()
  end
end
