# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :format_encoders, json: Jason

# General application configuration
config :todoop_ui, namespace: TodoopUi

# Configures the endpoint
config :todoop_ui, TodoopUi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cTujmS7SayaguJQK95ay8V+v+j8hEiW+B4p/y4cagkVO5+Z8Weouay6bEeq4MCmF",
  render_errors: [view: TodoopUi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TodoopUi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :todoop_ui, :generators, context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
