# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sso_bo,
  ecto_repos: [SsoBo.Repo]

# Configures the endpoint
config :sso_bo, SsoBo.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4X5K3MprcPPJorWmklN0xOQBPD4yAbeUZRGJufC3gV0D9bFbD/cVnVX4wuPDHz/1",
  render_errors: [view: SsoBo.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SsoBo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian configuration
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "SsoBo",
  ttl: { 1, :day},
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: SsoBo.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
