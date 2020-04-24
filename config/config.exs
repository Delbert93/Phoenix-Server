# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :gameServer, GameServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uKj0PbmHJtp8xivW7qn3DxWs8UNH7PlXRhClD6NHkh8GzuHglXgEOkJcU3VURr6x",
  render_errors: [view: GameServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GameServer.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "6SuvQZyR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Set up time infromation
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
