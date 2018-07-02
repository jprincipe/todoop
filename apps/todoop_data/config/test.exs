use Mix.Config

# Configure your database
config :todoop_data, TodoopData.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST"),
  database: "todoop_test",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox
