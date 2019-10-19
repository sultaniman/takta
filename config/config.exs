# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :takta,
  ecto_repos: [Takta.Repo]

config :takta_web,
  ecto_repos: [Takta.Repo],
  generators: [context_app: :takta, binary_id: true]

# Configures the endpoint
config :takta_web, TaktaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sW8Z4R65UNCmzmncL3J+Ug9ejI1e4RRT/1oU1qiGZ/QwKcED9yb4HwXA63wb104H",
  render_errors: [view: TaktaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TaktaWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
