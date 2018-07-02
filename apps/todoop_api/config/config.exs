# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todoop_api,
  namespace: TodoopApi

# Configures the endpoint
config :todoop_api, TodoopApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0f2GyxlEAmi27nsDV8iNshixa2kMY7pXYo0cKzzL3Y7Kfk5R6+uxcMQGSt2YNCK0",
  render_errors: [view: TodoopApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodoopApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :todoop_api, :generators, context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
