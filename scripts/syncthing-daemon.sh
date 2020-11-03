#!/bin/bash -xe

export HOME="$SNAP_COMMON"
export XDG_CONFIG_HOME="$SNAP_COMMON"
export STNOUPGRADE="1"

$SNAP/bin/syncthing -no-browser
