ARG PYTHON_VERSION=3.11.6-slim
FROM python:${PYTHON_VERSION}
# install git and pre-commit, git is a pre-requisite to pre-commit
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && pip install pre-commit \
    && rm -rf /var/lib/apt/lists/*