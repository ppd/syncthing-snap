#!/bin/sh

mkdir -p "$SNAP_USER_DATA/.config/autostart"

cp "$SNAP/syncthing-start.desktop" \
  "$SNAP_USER_DATA/.config/autostart/syncthing-start.desktop"
