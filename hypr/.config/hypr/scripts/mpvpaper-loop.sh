#!/usr/bin/env bash
# Keeps a video wallpaper running on all outputs. mpvpaper leaks memory,
# so it's restarted every INTERVAL; killing it (Super+W does `pkill -x
# mpvpaper`) restarts it immediately on every monitor.

OUTPUT="ALL"
WALL="$HOME/.wallpaper/cherry-blossom-ghost-of-tsushima-moewalls-com.mp4"
OPTS="--no-config --no-audio --loop-file=inf --cache=no --demuxer-max-bytes=50M --demuxer-max-back-bytes=0"

INTERVAL=$((2 * 60 * 60))  # restart every 2 hours (~240 MB/h leak)

while true; do
  timeout "$INTERVAL" mpvpaper -p -o "$OPTS" "$OUTPUT" "$WALL"
  sleep 1  # avoid a tight loop if mpvpaper fails to start
done
