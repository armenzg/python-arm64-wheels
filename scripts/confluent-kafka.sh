#!/bin/bash
# shellcheck disable=SC2086
#
# Script to generate arm64 wheels on an Apple Silicon host
#
# If you use direnv, you will be executing this script within a created venv
# that has all the dependencies needed for this work
#
# Based on https://github.com/psycopg/psycopg2/blob/cefb8181058342b9a4d0bd13b0fad920365d89d5/scripts/build/build_macos.sh
set -euo pipefail
set -x

# Build the wheel
# XXX: This for now bound to my machine
wheel=/Users/armenzg/Library/Caches/pip/wheels/19/7e/61/9363c31dd95693621c002a0db79cc8c00c59686af40cc901cf/confluent_kafka-1.5.0-cp38-cp38-macosx_11_0_arm64.whl

delocate-listdeps "$wheel"
# This should be around 116KB
du -h "$wheel" || exit 0
delocate-wheel --require-archs arm64 "$wheel" -w .
du -h "$wheel"
