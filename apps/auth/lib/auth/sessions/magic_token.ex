defmodule Auth.Sessions.MagicToken do
  @moduledoc false
  use Auth.{Model, Query}
  alias Auth.Sessions.MagicToken

  schema "magic_tokens" do
    field :token, :string
    field :user_id, :binary_id

    timestamps()
  end

  def new(params) do
    fields = [:token, :user_id]

    %MagicToken{}
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
