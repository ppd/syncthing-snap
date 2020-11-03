#!/bin/bash

realhome=$(getent passwd $UID | cut -d ':' -f 6)
export HOME="$realhome"
export XDG_CONFIG_HOME="$SNAP_USER_COMMON"
export STNOUPGRADE="1"

$SNAP/bin/syncthing "$@"
