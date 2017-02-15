use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sso_web, SsoWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sso_web, SsoWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sso",
  password: "sso",
  database: "sso_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
