# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :book,
  ecto_repos: [Book.Repo]

# Configures the endpoint
config :book, Book.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h4SkKBh9yZhLNC9fpq/+ISsP7uXfrW/u64Fq1pSoGzqfRGrrD81XO9z9eQzntgaV",
  render_errors: [view: Book.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Book.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :guardian, Guardian,
    allowed_algos: ["HS512"], # optional
    verify_module: Guardian.JWT,  # optional
    issuer: "Book",
    ttl: { 999, :years },
    allowed_drift: 2000,
    verify_issuer: true, # optional
    secret_key: "SF1MtA0TEQiGS+L26YmqrrAcxbbtTq46/V6HT/6k/R5RPEADEhrzquTk983d5RWO",
    serializer: Book.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
