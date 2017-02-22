#!/bin/bash
set -eux -o pipefail

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORK_DIR=`mktemp -d -p "${DIR}"`

function cleanup {
  rm -rf "${WORK_DIR}"
}

trap cleanup EXIT

mkdir -p ~/bin

mkdir -p "${WORK_DIR}/release/linux/amd64/"

cd "${WORK_DIR}/release/linux/amd64/"
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz -o ${WORK_DIR}/release/linux/amd64/drone.tar.gz
curl http://downloads.drone.io/release/linux/amd64/drone.sha256 -o ${WORK_DIR}/drone.sha256
sha256sum -c ${WORK_DIR}/drone.sha256 2>&1 | grep -q OK &

if [[ $? > 0 ]]
then
  echo "Error in Drone Download"
  exit 1
else
  echo "Drone Downloaded"
fi

tar zxvf drone.tar.gz

install -t ~/bin drone

cd ~

cleanup

echo "Please set the following (or update from dotfiles in .bashrc:"
echo "export DRONE_SERVER=https://drone.server.example"
echo "export DRONE_TOKEN=123_your_token"

exit 0
