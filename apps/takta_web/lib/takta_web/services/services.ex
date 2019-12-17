defmodule TaktaWeb.Services do
  @moduledoc false
  alias Takta.Util.Changeset
  alias TaktaWeb.Base.StatusResponse

  def bad_request(%Ecto.Changeset{} = changeset) do
    changeset
    |> Changeset.errors_to_json()
    |> StatusResponse.bad_request()
  end
end
