# syntax=docker/dockerfile:1.2

ARG PYTHON_VERSION=3.11.8
ARG VARIANT=alpine
ARG PRE_COMMIT_VERSION=3.7.0
ARG PACKAGES_LIST="bash curl"
ARG SCALA_VERSION=""
ARG INSTALL_COURSIER=false

FROM python:${PYTHON_VERSION}-${VARIANT}

# Redeclare ARGs needed after FROM
ARG PRE_COMMIT_VERSION
ARG PACKAGES_LIST
ARG SCALA_VERSION
ARG INSTALL_COURSIER

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

# Install Coursier and then use it to install Scala/SBT if requested
RUN if [ "$INSTALL_COURSIER" = "true" ] ; then \
      echo "Installing Coursier..." ; \
      curl -fLo /usr/local/bin/cs https://github.com/coursier/launchers/raw/master/coursier && \
      chmod +x /usr/local/bin/cs && \
      # Install specific Scala version using Coursier if SCALA_VERSION is set
      if [ -n "$SCALA_VERSION" ]; then \
        echo "Installing Scala version ${SCALA_VERSION} using Coursier..."; \
        cs install "scala:${SCALA_VERSION}" --install-dir /usr/local/bin && \
        echo "Installing sbt using Coursier..."; \
        cs install sbt --install-dir /usr/local/bin; \
      else \
        echo "SCALA_VERSION not set, skipping Scala/SBT installation via Coursier."; \
      fi; \
    else \
      echo "Skipping Coursier installation." ; \
    fi


# configuration
ENV XDG_CACHE_HOME=/tmp/.cache \
    XDG_CONFIG_HOME=/tmp/.config \
    COURSIER_CACHE=/tmp/.cache/coursier

RUN git config --system --add safe.directory '*' \
    && adduser -S -D -H pre-commit \
    && addgroup pre-commit \
    && addgroup pre-commit pre-commit 

WORKDIR /home/pre-commit/
COPY .pre-commit-config.yaml README.md ./
USER pre-commit

ENTRYPOINT []