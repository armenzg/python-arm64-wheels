# This Dockerfile helps produce the confluent-kafka wheel that Sentry uses
# If you run this on an arm64 host you will get an arm64 wheel
ARG PYTHON_VERSION=3.8.12
FROM python:${PYTHON_VERSION} AS application

RUN set -ex; \
    apt-get update && apt-get install -y librdkafka-dev --no-install-recommends; \
    pip install confluent-kafka==1.5.0; \
    cp $(find $(pip cache dir) -name "*conf*") .; \
    rm -rf /var/lib/apt/lists/*;