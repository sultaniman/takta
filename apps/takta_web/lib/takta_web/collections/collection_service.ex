defmodule TaktaWeb.CollectionService do
  @moduledoc false
  alias Takta.Collections
  alias Takta.Collections.CollectionMapper
  alias Takta.Whiteboards.WhiteboardMapper
  alias TaktaWeb.Base.StatusResponse
  alias TaktaWeb.Services

  def create_for_user(user, %{"name" => name}) do
    params = %{name: name, owner_id: user.id}

    case Collections.create(params) do
      {:ok, collection} ->
        collection
        |> CollectionMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Services.bad_request()
    end
  end

  def list_for_user(user) do
    StatusResponse.ok(%{collections: json_for_user(user.id)})
  end

  def detail_for_user(user, collection_id) do
    case Collections.has_owner?(collection_id, user.id) do
      false -> StatusResponse.permission_denied()
      true ->
        user.id
        |> json_for_user()
        |> StatusResponse.ok()
    end
  end

  def update_for_user(user, collection_id, new_name) do
    case Collections.has_owner?(collection_id, user.id) do
      false -> StatusResponse.permission_denied()
      true ->
        collection = Collections.find_by_id(collection_id)
        case Collections.update(collection, %{name: new_name}) do
          {:ok, updated} ->
            updated
            |> CollectionMapper.to_json_basic()
            |> StatusResponse.ok()

          {:error, %Ecto.Changeset{} = changeset} ->
            changeset
            |> Services.bad_request()
        end
    end
  end

  def delete_for_user(user, collection_id) do
    case Collections.has_owner?(collection_id, user.id) do
      false -> StatusResponse.permission_denied()
      true ->
        case Collections.delete(collection_id) do
          {:ok, deleted} ->
            deleted
            |> CollectionMapper.to_json_basic()
            |> StatusResponse.ok()

          {:error, %Ecto.Changeset{} = changeset} ->
            changeset
            |> Services.bad_request()
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

      StatusResponse.ok(%{whiteboards: whiteboards})
    end
  end

  defp json_for_user(user_id) do
    user_id
    |> Collections.find_for_user()
    |> Enum.map(&CollectionMapper.to_json_basic/1)
  end
end
