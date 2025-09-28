#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -w <workflow.yml> -e <event.json> -j <job_id> [-n <event_name>]

This script is a helper for running GitHub Actions workflows locally with 'act'.
It wraps the 'act' CLI with some sanity checks and defaults.

Required arguments:
  -w <workflow.yml>   Path to the workflow file you want to run (e.g. .github/workflows/pr-to-master.yml)
  -e <event.json>     Path to a JSON file describing the event payload (e.g. .github/events/pr-to-master.json)
  -j <job_id>         The job ID inside the workflow to run (see 'jobs:' in the workflow file)

Optional arguments:
  -n <event_name>     The event name to simulate (default: 'pull_request')

Examples:
  # Run the 'integration' job from the PR-to-release workflow
  $0 -w .github/workflows/pr-to-release.yml \\
     -e .github/events/pr-to-release.json \\
     -j integration -n pull_request

  # Run the 'rc' job from the PR-to-master workflow
  $0 -w .github/workflows/pr-to-master.yml \\
     -e .github/events/pr-to-master.json \\
     -j rc -n pull_request

Notes:
  - This script is only for local development/testing, not for CI servers.
  - It checks that 'act' and 'docker' are installed and usable.
  - You can override defaults with environment variables:
      ACT_IMAGE_MAP   to choose the act runner image mapping
      ACT_PULL_FLAG   to force pulling images (e.g. --pull)
EOF
  exit 2
}

# do not run in real ci
[[ "${GITHUB_ACTIONS:-}" == "true" ]] && { echo "This is for local runs only."; exit 1; }

# prerequisites for running act
command -v act >/dev/null 2>&1    || { echo "Error: install 'act' (https://nektosact.com)."; exit 127; }
command -v docker >/dev/null 2>&1 || { echo "Error: Docker CLI not found."; exit 127; }
docker info >/dev/null 2>&1       || { echo "Error: Docker daemon not running / no perms."; exit 1; }

# defaults & flags
EVENT_NAME="pull_request"
IMAGE_MAP="${ACT_IMAGE_MAP:-ubuntu-22.04=ghcr.io/catthehacker/ubuntu:act-22.04}"
PULL_FLAG="${ACT_PULL_FLAG:---pull=false}"

WORKFLOW=""
EVENT=""
JOB_ID=""

while getopts ":w:e:j:n:" opt; do
  case "$opt" in
    w) WORKFLOW="$OPTARG" ;;
    e) EVENT="$OPTARG" ;;
    j) JOB_ID="$OPTARG" ;;
    n) EVENT_NAME="$OPTARG" ;;
    *) usage ;;
  esac
done

[[ -n "$WORKFLOW" && -n "$EVENT" && -n "$JOB_ID" ]] || usage
[[ -f "$WORKFLOW" ]] || { echo "Workflow not found: $WORKFLOW"; exit 1; }
[[ -f "$EVENT" ]]    || { echo "Event payload not found: $EVENT"; exit 1; }

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

exec act "$EVENT_NAME" \
  -W "$WORKFLOW" \
  -e "$EVENT" \
  -j "$JOB_ID" \
  -P "$IMAGE_MAP" \
  $PULL_FLAG
