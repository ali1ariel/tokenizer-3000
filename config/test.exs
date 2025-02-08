import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tokenizer, Tokenizer.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "tokenizer_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tokenizer, TokenizerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5+ypnxsiDqJKWliXSe3ew+I3NvUM98XFRyX+1FPSg93W7CZZsBRQFpG5NFiYhU3N",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :tokenizer, release_timer: 2
