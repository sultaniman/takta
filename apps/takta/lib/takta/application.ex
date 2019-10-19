defmodule Takta.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Takta.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Takta.Supervisor)
  end
end
