import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :raffley, RaffleyWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Raffley.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

# config/prod.exs

import Config

# Override log level and backend for production
config :logger,
  level: :info,
  backends: [{LoggerFileBackend, :file_log}] # Use a file backend for production

config :logger, :file_log,
  path: "/var/log/raffley.log",
  level: :info
