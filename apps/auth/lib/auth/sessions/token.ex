defmodule Auth.Sessions.Token do
  @moduledoc false
  use Auth.{Model, Query}
  alias Auth.Sessions.Token

  schema "tokens" do
    field :token, :string
    field :user_id, :binary_id

    timestamps()
  end

  def new(params) do
    fields = [:token, :user_id]

    %Token{}
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
