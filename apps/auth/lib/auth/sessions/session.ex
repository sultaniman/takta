defmodule Auth.Sessions.Session do
  @moduledoc false
  use Auth.{Model, Query}
  alias Auth.Sessions.Session

  schema "sessions" do
    field :token, :string
    field :user_id, :binary_id

    timestamps()
  end

  def new(params) do
    fields = [:token, :user_id]

    %Session{}
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
