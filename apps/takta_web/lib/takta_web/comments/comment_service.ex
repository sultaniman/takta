defmodule TaktaWeb.CommentService do
  @moduledoc false
  alias Takta.Comments
  alias Takta.Comments.CommentMapper
  alias TaktaWeb.Base.StatusResponse

  def create(params) do
    case Comments.create(params) do
      {:ok, comment} ->
        comment
        |> CommentMapper.to_json_basic()
        |> StatusResponse.ok()

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
        |> Takta.Util.Changeset.errors_to_json()
        |> StatusResponse.bad_request()
    end
  end
end
