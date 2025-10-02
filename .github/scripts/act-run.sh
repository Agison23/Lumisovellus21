#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 -w <workflow.yml> [-j <job_id>] [-n <event_name>] [-e <event.json>]

This script is a helper for running GitHub Actions workflows locally with 'act'.

Required:
  -w <workflow.yml>   Path to the workflow file (e.g. .github/workflows/pr-to-master.yml)

Optional:
  -j <job_id>         The job ID inside the workflow (under 'jobs:'). If omitted, run all jobs.
  -n <event_name>     Event name to simulate (default: 'pull_request')
  -e <event.json>     JSON payload file for the event (optional)

Examples:
  $0 -w .github/workflows/pr-to-release.yml -n pull_request
  $0 -w .github/workflows/ci.yml -j build -n workflow_dispatch
EOF
  exit 2
}

# Do not run in real CI
[[ "${GITHUB_ACTIONS:-}" == "true" ]] && { echo "This is for local runs only."; exit 1; }

# prerequisites
command -v act >/dev/null 2>&1    || { echo "Error: install 'act' (https://nektosact.com)."; exit 127; }
command -v docker >/dev/null 2>&1 || { echo "Error: Docker CLI not found."; exit 127; }
docker info >/dev/null 2>&1       || { echo "Error: Docker daemon not running / no perms."; exit 1; }

# defaults & flags
EVENT_NAME="pull_request"
IMAGE_MAP="${ACT_IMAGE_MAP:-ubuntu-22.04=ghcr.io/catthehacker/ubuntu:act-22.04}"
PULL_FLAG="${ACT_PULL_FLAG:---pull=false}"

WORKFLOW=""
JOB_ID=""
EVENT_FILE=""

while getopts ":w:j:n:e:" opt; do
  case "$opt" in
    w) WORKFLOW="$OPTARG" ;;
    j) JOB_ID="$OPTARG" ;;
    n) EVENT_NAME="$OPTARG" ;;
    e) EVENT_FILE="$OPTARG" ;;
    *) usage ;;
  esac
done

[[ -n "$WORKFLOW" ]] || usage
[[ -f "$WORKFLOW" ]] || { echo "Workflow not found: $WORKFLOW"; exit 1; }
[[ -z "$EVENT_FILE" || -f "$EVENT_FILE" ]] || { echo "Event payload not found: $EVENT_FILE"; exit 1; }

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

args=("$EVENT_NAME" -W "$WORKFLOW" -P "$IMAGE_MAP" "$PULL_FLAG")
[[ -n "$JOB_ID"    ]] && args+=(-j "$JOB_ID")
[[ -n "$EVENT_FILE" ]] && args+=(-e "$EVENT_FILE")

exec act "${args[@]}" -s ACT=true
