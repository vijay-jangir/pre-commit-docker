# syntax=docker/dockerfile:1.2

ARG PYTHON_VERSION=3.11.8
ARG VARIANT=alpine
FROM python:${PYTHON_VERSION}-${VARIANT}
ARG PRE_COMMIT_VERSION=3.7.0
ARG PACKAGES_LIST="bash"

LABEL maintainer="Vijay Jangir <6284383+vijay-jangir@users.noreply.github.com>" \
      version="1.0" \
      python=${PYTHON_VERSION} \
      pre_commit_version=${PRE_COMMIT_VERSION} \
      description="This is a custom Python image with pre-commit installed."


ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    SAMPLE_PRE_COMMIT_CONFIG=/home/pre-commit/.pre-commit-config.yaml

# package installs with mount
RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add git ${PACKAGES_LIST} 

# pip install with mount
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install "pre-commit==${PRE_COMMIT_VERSION}"

# configuration
ENV XDG_CACHE_HOME=/tmp/.cache \
    XDG_CONFIG_HOME=/tmp/.config
RUN git config --system --add safe.directory '*' \
    && adduser -S -D -H pre-commit \
    && addgroup pre-commit \
    && addgroup pre-commit pre-commit 

WORKDIR /home/pre-commit/
COPY .pre-commit-config.yaml README.md ./
USER pre-commit

ENTRYPOINT []