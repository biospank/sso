use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sso, Sso.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sso, Sso.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sso_#{Mix.env}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Bamboo test
config :bamboo, :refute_timeout, 10

config :sso, Sso.Mailer,
  adapter: Bamboo.TestAdapter
