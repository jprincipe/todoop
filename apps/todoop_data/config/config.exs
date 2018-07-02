use Mix.Config

config :todoop_data, ecto_repos: [TodoopData.Repo]

import_config "#{Mix.env}.exs"
