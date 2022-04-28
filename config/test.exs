import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :google_search_data_viewer, GoogleSearchDataViewer.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "google_search_data_viewer_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :google_search_data_viewer, GoogleSearchDataViewerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "e1m+hwhHd1+CaEfhN2jYuBelFkOX/CU8c+ngM+kM2HqsUjUSlNWMJFC7Kh0zH8Qz",
  server: true

config :google_search_data_viewer, :sql_sandbox, true

config :wallaby,
  otp_app: :google_search_data_viewer,
  chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
  screenshot_dir: "tmp/wallaby_screenshots",
  screenshot_on_failure: true

# In test we don't send emails.
config :google_search_data_viewer, GoogleSearchDataViewer.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

config :google_search_data_viewer, Oban, crontab: false, queues: false, plugins: false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configurations for ExVCR
config :exvcr,
  vcr_cassette_library_dir: "test/support/fixtures/vcr_cassettes",
  ignore_localhost: true
