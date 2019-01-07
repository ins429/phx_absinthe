# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :phx_absinthe, PhxAbsintheWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lyMq9UTxhsNweVGBE37MTuMnzwqhllK9aZPmqvLiPPEKdgGddvNlDYZ908DPoxKe",
  render_errors: [view: PhxAbsintheWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhxAbsinthe.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian,
  issuer: "PhxAbsinthe",
  verify_issuer: true,
  serializer: PhxAbsinthe.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
