# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sso,
  ecto_repos: [Sso.Repo]

# Configures the endpoint
config :sso, Sso.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qfVx9LiiknG+ZEt/rtt/NjQr/8ifiwCC83A6kYkcDJRZuKoTSQv2a4+uJocfnE3f",
  render_errors: [view: Sso.ErrorView, accepts: ~w(json)],
  pubsub: [name: Sso.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# configurations deeded to change mime type accept headers
##### begin
config :mime, :types, %{
  "application/vnd.dardy.sso.v1+json" => ["v1"]
  #, "application/vnd.app.v2+json" => ["v2"]
}

config :phoenix, :format_encoders, "v1": Poison

config :plug, :statuses, %{
  451 => "Unavailable For Legal Reasons",
  498 => "Invalid Token"
}
##### end

# Guardian configuration overridden by umbrella config
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Dardy",
  ttl: { 1, :day},
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: Sso.GuardianSerializer

config :sso, :recipient_email_notification, "dirosa.ilaria@gmail.com"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
