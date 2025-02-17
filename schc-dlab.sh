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
  start           Start the schc-dlab container
  core-daemon     Start the CORE daemon
  core-gui        Open the CORE GUI program
  wireshark       Open Wireshark
  bash            Open a bash session within the container
  stop            Stop the schc-dlab container
  remove          Remove the schc-dlab container and image
EOF
  exit
}

commands='install start core-daemon core-gui wireshark bash stop remove'

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
  ! [[ " ${commands} " =~ .*\ ${cmd}\ .* ]] && \
    msg "Invalid command '${cmd}'." && usage

  return 0
}

docker_run_for_linux() {
  docker run -itd --name schc-dlab \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${IMPLEMS_DIR}:/root/schc-implementations --privileged schc-dlab:generic
}

xhost_for_linux() {
  xhost +local:root # enable xhost access to the root user
}

docker_run_for_mac() {
  local IP=$1
  docker run -itd --name schc-dlab \
    -e DISPLAY="${IP}:0" \
    -v ${IMPLEMS_DIR}:/root/schc-implementations --privileged schc-dlab:generic
}

xhost_for_mac() {
  local IP=$1
  /opt/X11/bin/xhost "$IP" # enable xhost access to the display address
}

parse_params "$@"

# setup
# check if we're running on MacOS
running_on_mac=false
os_name=$(uname)
if [[ "$os_name" == "Darwin" ]]; then
  running_on_mac=true
fi
    
# main
msg "Running '${cmd}' command..."
cd ${script_dir}


case ${cmd} in
# commands='install start core wireshark bash stop remove'

  (install)
    # first we must build EMANE python bindings
    [[ -z "$(docker images -q emane-python:latest 2> /dev/null)" ]] && \
      docker build -t emane-python -f ./Dockerfile.emane-python .
    # check if the image does not exist already & build
    [[ -z "$(docker images -q schc-dlab:generic 2> /dev/null)" ]] && \
      docker build -t schc-dlab:generic . 
    # get schc-implementations/ location
    IMPLEMS_DIR=${IMPLEMS_DIR:-"${HOME}/schc-implementations"}
    while ! [ -d ${IMPLEMS_DIR} ]; do
      msg "${IMPLEMS_DIR} not found."
      read -p "Enter schc-implementations/ path: " IMPLEMS_DIR
    done
    msg "Found ${IMPLEMS_DIR}."
    # create container
    if $running_on_mac; then
      IP=$(/usr/sbin/ipconfig getifaddr en0)
      docker_run_for_mac $IP
      xhost_for_mac $IP
    else
      docker_run_for_linux
      xhost_for_linux
    fi
    docker ps | grep schc-dlab
    ;;

  (start)
    docker start schc-dlab
    if $running_on_mac; then
      IP=$(/usr/sbin/ipconfig getifaddr en0)
      xhost_for_mac $IP # echo "Run bash and set DISPLAY=$IP"
    else
      xhost_for_linux
    fi
    docker ps | grep schc-dlab
    ;;

  (core-daemon)
    docker exec -itd schc-dlab core-daemon
    ;;

  (core-gui)
    docker exec -it schc-dlab rm -rf /tmp/pycore.1
    docker exec -it schc-dlab core-gui
    ;;

  (wireshark)
    docker exec -itd schc-dlab wireshark
    ;;

  (bash)
    docker exec -it schc-dlab bash
    ;;

  (stop)
    docker stop schc-dlab
    docker ps -a | grep schc-dlab
    ;;

  (remove)
    # rm container if exists, then image
    [[ "$(docker ps -a -q -f name=schc-dlab)" ]] && docker rm schc-dlab
    docker rmi schc-dlab:generic
    ;;

  (*)
    die "Unknown command!"
    ;;

esac

