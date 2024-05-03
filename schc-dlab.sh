#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [OPTION] command

SCHC Docker Lab command manager

Available options:
  -h, --help      Print this help and exit
  -v, --verbose   Print script debug info

Available commands:
  install         Build and run the schc-dlab docker container
  start           Start the docker container if stopped
  core            Open the CORE program
  wireshark       Open Wireshark
  bash            Open a bash session within the container
  stop            Stop the schc-dlab container
  remove          Remove the schc-dlab container and image
EOF
  exit
}

commands='install start core wireshark bash stop remove'

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && msg "No command provided." && usage
  [[ ${#args[@]} -gt 1 ]] && msg "Only 1 command is allowed." && usage
  cmd=${args[0]}
  ! [[ " ${commands} " =~ .*\ ${cmd}\ .* ]] && msg "Invalid command '${cmd}'." && usage

  return 0
}

parse_params "$@"

# check valid command
cmd=${args[0]}
case ${cmd} in

esac
msg "Running '${cmd}' command."


