use Mix.Config

config :todoop_data, ecto_repos: [TodoopData.Repo], types: TodoopData.PostgresTypes

config :ecto, json_library: Jason

import_config "#{Mix.env()}.exs"
