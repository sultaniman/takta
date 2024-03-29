defmodule TaktaWeb.CollectionService do
  @moduledoc false
  alias Takta.Collections
  alias Takta.Collections.CollectionMapper
  alias Takta.Whiteboards.WhiteboardMapper
  alias TaktaWeb.{Permissions, Services}

  import TaktaWeb.Base.StatusResponse

  def create_for_user(user, name) do
    params = %{name: name, owner_id: user.id}

    case Collections.create(params) do
      {:ok, collection} ->
        collection
        |> CollectionMapper.to_json_basic()
        |> ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Services.bad_request()
    end
  end

  def list_for_user(user) do
    ok(%{collections: json_for_user(user.id)})
  end

  def detail_for_user(user, collection_id) do
    case Collections.find_by_id(collection_id) do
      nil -> not_found()
      collection ->
        is_member = Collections.has_member?(collection_id, user.id)
        can_manage = Permissions.can_manage_collection?(user, collection)

        if is_member or can_manage do
          collection
          |> CollectionMapper.to_json_basic()
          |> ok()
        else
          permission_denied()
        end
    end
  end

  def update_for_user(user, collection_id, new_name) do
    case Collections.find_by_id(collection_id) do
      nil -> not_found()
      collection ->
        if Permissions.can_manage_collection?(user, collection) do
          call_action(fn ->
            Collections.update(collection, %{name: new_name})
          end)
        else
          permission_denied()
        end
    end
  end

  def delete_for_user(user, collection_id) do
    case Collections.find_by_id(collection_id) do
      nil -> not_found()
      collection ->
        if Permissions.can_manage_collection?(user, collection) do
          call_action(fn ->
            Collections.delete(collection_id)
          end)
        else
          permission_denied()
        end
    end
  end

  def whiteboards_for_user(user, collection_id) do
    has_owner = Collections.has_owner?(collection_id, user.id)
    has_member = Collections.has_member?(collection_id, user.id)
    if has_owner or has_member do
      collection =
        collection_id
        |> Collections.find_by_id()
        |> Collections.preload_all()

      whiteboards =
        collection.whiteboards
        |> Enum.map(&WhiteboardMapper.to_json_basic/1)

      ok(%{whiteboards: whiteboards})
    end
  end

  def add_whiteboards(user, collection_id, whiteboards) do
    case Collections.find_by_id(collection_id) do
      nil -> not_found()
      collection ->
        if Permissions.can_manage_collection?(user, collection) do
          call_action(fn ->
            Collections.add_whiteboards(collection_id, whiteboards)
          end)
        else
          permission_denied()
        end
    end
  end

  defp call_action(action) do
    case action.() do
      {:ok, result} ->
        result
        |> CollectionMapper.to_json_basic()
        |> ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Services.bad_request()

      {_updated_rows, _} ->
        ok()
    end
  end

  defp json_for_user(user_id) do
    user_id
    |> Collections.find_for_user()
    |> Enum.map(&CollectionMapper.to_json_basic/1)
  end
end
