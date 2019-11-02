defmodule Storage.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Storage.Worker.start_link(arg)
      # {Storage.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Storage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
