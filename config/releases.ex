import Config

config :idp_web, TaktaWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  signing_salt: System.fetch_env!("SIGNING_SALT")

config :takta, Takta.Repo, url: System.fetch_env!("DATABASE_URL")
config :auth, Auth.Repo, url: System.fetch_env!("DATABASE_URL")

config :auth,
  password_hash_salt: System.fetch_env!("PASSWORD_HASH_SALT")
