defmodule Takta.Members do
  @moduledoc false
  use Takta.Query
  alias Takta.Members.{Member, MemberForms}

  def all, do: Repo.all(Member)

  def find_by_id(id) do
    Repo.one(from m in Member, where: m.id == ^id)
  end

  def whiteboard_has_member?(wid, user_id) do
    query = from(
      m in Member,
      where: m.member_id == ^user_id and m.whiteboard_id == ^wid
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

  def delete(cid) do
    case find_by_id(cid) do
      nil -> {:error, :not_found}
      member -> member |> Repo.delete()
    end
  end
end
