use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :sso, Sso.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :sso, Sso.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sso",
  password: "sso",
  database: "sso_dev",
  hostname: "localhost",
  pool_size: 10

# Configure Bamboo dev
config :sso, Sso.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("BAMBOO_MAILER_SERVER"),
  port: 587, # tls / 465 ssl
  username: System.get_env("BAMBOO_MAILER_USERNAME"),
  password: System.get_env("BAMBOO_MAILER_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1

config :sso, :recipient_email_notification, "dirosa.ilaria@gmail.com"
