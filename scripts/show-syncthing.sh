#!/bin/bash -e

first_run_marker="$SNAP_USER_COMMON/is-not-first-run"

is_syncthing_running() {
  pgrep -x syncthing -u $UID > /dev/null
}

is_first_run() {
  test ! -f "$first_run_marker"
}

setup_autostart() {
  user_wants_autostart=$($SNAP/bin/http-prompt $SNAP/prompt-for-autostart.html)
  touch "$first_run_marker"
  if [ "$user_wants_autostart" = "yes" ]; then
    $SNAP/bin/enable-autostart.sh
  fi
}

launch_syncthing() {
  if is_syncthing_running; then 
    $SNAP/bin/launch-syncthing.sh -browser-only
  else
    $SNAP/bin/launch-syncthing.sh \
        -logfile="$SNAP_USER_COMMON/log.txt" \
        "$@" \
        &> /dev/null &
  fi
}

if is_first_run; then
  # the autostart prompt will forward the user to syncthing
  launch_syncthing -no-browser
  setup_autostart
else
  launch_syncthing
fi
