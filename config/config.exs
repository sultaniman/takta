import Config

# Configure Mix tasks and generators
config :takta,
  ecto_repos: [Takta.Repo]

config :takta_web,
  ecto_repos: [Takta.Repo],
  signing_salt: System.get_env("SIGNING_SALT", "DEFAULT_SIGNING_SALT"),
  generators: [context_app: :takta, binary_id: true]

# Configures the endpoint
config :takta_web, TaktaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE", "DEFAULT_SECRET_KEY"),
  render_errors: [view: TaktaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TaktaWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :takta,
  password_min_length: 8

config :auth,
  ecto_repos: [Auth.Repo]

config :auth, Auth.Guardian,
  issuer: "auth",
  secret_key: System.get_env("SECRET_KEY_BASE", "DEFAULT_SECRET_KEY"),
  ttl: {15, :minutes}

config :auth,
  password_hash_salt: System.get_env("PASSWORD_HASH_SALT", "hash-hash"),

  # Argon2
  t_cost: 1,
  m_cost: 8,
  hashlen: 4

# config :oauth2, debug: true

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {
      Ueberauth.Strategy.Google,
      [
        default_scope: "email profile",
        prompt: "select_account",
        access_type: "offline"
      ]
    },
    github: {
      Ueberauth.Strategy.Github,
      [
        default_scope: "user",
        send_redirect_uri: false
      ]
    }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
