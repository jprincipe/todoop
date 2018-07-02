use Mix.Config

# Configure your database
config :todoop_data, TodoopData.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todoop_data_dev",
  hostname: "localhost",
  pool_size: 10
