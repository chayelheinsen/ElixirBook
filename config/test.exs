use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :book, Book.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :book, Book.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "chayelheinsen",
  password: "",
  database: "book_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
