#!/usr/bin/env bash
set -euo pipefail

act pull_request \
  -W .github/workflows/pr-to-release.yml \
  -e .github/events/pr-to-release.json \
  -j integration \
  -P ubuntu-22.04=ghcr.io/catthehacker/ubuntu:act-22.04 \
  --pull=false