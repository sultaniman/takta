defmodule TaktaWeb.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      TaktaWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TaktaWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TaktaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
