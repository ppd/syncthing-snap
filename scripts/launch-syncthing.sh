#!/bin/bash

realhome=$(getent passwd $UID | cut -d ':' -f 6)
export HOME="$realhome"
export XDG_CONFIG_HOME="$SNAP_USER_COMMON"

$SNAP/bin/syncthing "$@"
