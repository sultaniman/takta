import Config

config :takta_web, TaktaWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  signing_salt: System.fetch_env!("SIGNING_SALT")

config :takta_web,
  uploader: TaktaWeb.Uploaders.S3,
  upload_to: "das-whiteboards"

config :takta, Takta.Repo,
  migration_timestamps: [type: :utc_datetime_usec],
  url: System.fetch_env!("DATABASE_URL")

config :auth, Auth.Repo,
  migration_timestamps: [type: :utc_datetime_usec],
  url: System.fetch_env!("DATABASE_URL")

config :auth,
  password_hash_salt: System.fetch_env!("PASSWORD_HASH_SALT")

