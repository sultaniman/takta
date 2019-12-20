defmodule Takta.Members do
  @moduledoc false
  use Takta.Query
  alias Takta.Members.{Member, MemberForms}

  def all, do: Repo.all(Member)

  def find_by_id(nil), do: nil
  def find_by_id(id) do
    Repo.one(from m in Member, where: m.id == ^id)
  end

  # TODO: write test
  def find_member(user_id, whiteboard_id) do
    query = from(
      m in Member,
      where: m.member_id == ^user_id and m.whiteboard_id == ^whiteboard_id
    )

    Repo.one(query)
  end

  def whiteboard_has_member?(whiteboard_id, user_id) do
    query = from(
      m in Member,
      where: m.member_id == ^user_id and m.whiteboard_id == ^whiteboard_id
    )

    Repo.exists?(query)
  end

  def create(params) do
    %Member{}
    |> MemberForms.new(params)
    |> Repo.insert()
  end

  def update(%Member{} = member, params) do
    member
    |> MemberForms.update(params)
    |> Repo.update()
  end

  def delete(member_id) do
    case find_by_id(member_id) do
      nil -> {:error, :not_found}
      member -> member |> Repo.delete()
    end
  end

  def preload_all(member) do
    member
    |> Repo.preload(:member)
    |> Repo.preload(:whiteboard)
  end
end
