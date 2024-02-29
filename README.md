A lightweight docker image for running pre-commit in CI

Configuration:
- by default the hook install will cache at /tmp/.cache/pre-commit. It's recommended that you mount this for caching b/w multiple builds.
- You can change XDG_CACHE_HOME if you want to change path of .cache inside the docker container.
- A sample pre commit config is provided, that can be accessed using ${SAMPLE_PRE_COMMIT_CONFIG}