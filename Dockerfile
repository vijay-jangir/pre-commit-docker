ARG PYTHON_VERSION=3.11.8-slim
FROM python:${PYTHON_VERSION}

LABEL maintainer="Vijay Jangir <6284383+vijay-jangir@users.noreply.github.com>" \
      version="1.0" \
      description="This is a custom Python image with pre-commit installed."

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PRE_COMMIT_VERSION=3.6.2

# install git and pre-commit, git is a pre-requisite to pre-commit
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && pip install pre-commit==${PRE_COMMIT_VERSION} \
    && rm -rf /var/lib/apt/lists/*
