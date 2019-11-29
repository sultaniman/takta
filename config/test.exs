import Config

# Configure your database
config :takta, Takta.Repo,
  username: "postgres",
  password: "postgres",
  database: "takta_test",
  hostname: "localhost",
  migration_timestamps: [type: :naive_datetime_usec],
  pool: Ecto.Adapters.SQL.Sandbox

config :auth, Auth.Repo,
  username: "postgres",
  password: "postgres",
  database: "takta_test",
  hostname: "localhost",
  migration_timestamps: [type: :naive_datetime_usec],
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :takta_web, TaktaWeb.Endpoint,
  http: [port: 4002],
  server: false

config :takta_web,
  uploader: TaktaWeb.Uploaders.MockUploader,
  upload_to: "takta-whiteboards"

# Print only warnings and errors during test
config :logger, level: :warn

config :takta,
  password_min_length: 3

config :auth,
  password_hash_salt: "saltysalty",

  # Argon2
  t_cost: 1,
  m_cost: 8,
  hashlen: 4,

  session_ttl_days: 1
