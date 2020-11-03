#!/bin/bash -e

is_syncthing_running() {
  pgrep -x syncthing -u $UID > /dev/null && return 0 || return 1
}

setup_autostart() {
  if [ ! -f "$SNAP_USER_COMMON/is-not-first-run" ]; then
    is_first_run="yes"
  fi

  if [ "$is_first_run" = "yes" ]; then
    user_wants_autostart=$($SNAP/bin/http-prompt $SNAP/prompt-for-autostart.html)
    touch "$SNAP_USER_COMMON/is-not-first-run"
    if [ "$user_wants_autostart" = "yes" ]; then
      $SNAP/bin/enable-autostart.sh
    fi  
  fi  
}

setup_autostart

if ! is_syncthing_running; then
  $SNAP/bin/launch-syncthing.sh -logfile="$SNAP_USER_COMMON/log.txt" &> /dev/null &
else
  $SNAP/bin/launch-syncthing.sh -browser-only
fi
