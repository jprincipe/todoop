use Mix.Config

config :todoop_data, TodoopData.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todoop_development",
  hostname: "localhost",
  port: 5432,
  pool_size: 10
