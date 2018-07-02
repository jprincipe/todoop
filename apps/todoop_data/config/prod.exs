use Mix.Config

config :todoop_data, TodoopData.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST"),
  database: "gonano",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
