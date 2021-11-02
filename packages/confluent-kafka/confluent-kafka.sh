#!/bin/bash
# shellcheck disable=SC2086
#
# Script to generate arm64 wheels for Linux/Mac
#
# If you use direnv, you will be executing this script within a created venv
# that has all the dependencies needed for this work
#
# Based on:
# - https://github.com/MacPython/wiki/wiki/Spinning-wheels
# - https://github.com/psycopg/psycopg2/blob/cefb8181058342b9a4d0bd13b0fad920365d89d5/scripts/build/build_macos.sh
set -euo pipefail

if [ ! -f confluent_kafka-1.5.0-cp38-cp38-linux_aarch64.whl ]; then
    # Let's create the Linux wheel
    docker build . -t python-arm64-wheels/confluent-kafka
    container_id=$(docker create python-arm64-wheels/confluent-kafka)
    docker cp $container_id:"/confluent_kafka-1.5.0-cp38-cp38-linux_aarch64.whl" .
    docker rm $container_id
fi

if [ ! -f confluent_kafka-1.5.0-cp38-cp38-macosx_11_0_arm64.whl ]; then
    # Build the Mac wheel
    HOMEBREW_NO_AUTO_UPDATE=1 brew install librdkafka
    # For some reason, pdm did not install the binary
    pip install delocate

    set -x
    pip uninstall -y confluent-kafka
    pip install confluent-kafka==1.5.0
    # Find the wheel in the cache; it assums only one version
    cached_wheel="$(find "$(pip cache dir)" -name "*conf*")"

    delocate-listdeps "$cached_wheel"
    # This should be around 116KB
    du -h "$cached_wheel" || exit 0
    delocate-wheel --require-archs arm64 "$cached_wheel" -w .
    du -h "confluent_kafka-1.5.0-cp38-cp38-macosx_11_0_arm64.whl"
    set +x

    pip uninstall -y confluent-kafka
fi

echo "Upload these wheels:"
ls -l confluent_kafka-*.whl
