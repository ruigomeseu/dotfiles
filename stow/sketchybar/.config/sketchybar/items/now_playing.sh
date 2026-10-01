#!/bin/bash
sketchybar --add event now_playing_change
sketchybar --add item now_playing left --set now_playing \
  script="$PLUGIN_DIR/now_playing.sh" click_script="$PLUGIN_DIR/now_playing.sh" \
  update_freq=10 label='Play something' label.max_chars=25 \
  label.scroll_duration=500 label.padding_left=4 label.padding_right=6 \
  icon='' icon.color="$YELLOW" icon.padding_left=12 icon.padding_right=8 \
  --subscribe now_playing now_playing_change mouse.clicked
sketchybar --add item now_playing.sep left --set now_playing.sep \
  script="$PLUGIN_DIR/now_playing.sh" label='|' label.color="$MUTED" \
  icon.drawing=off --subscribe now_playing.sep now_playing_change
for control in prev toggle next; do
  case "$control" in prev) glyph='';; toggle) glyph='';; next) glyph='';; esac
  sketchybar --add item "now_playing.$control" left \
    --set "now_playing.$control" script="$PLUGIN_DIR/now_playing.sh" \
    icon="$glyph" icon.color="$SUBTEXT" icon.padding_left=8 icon.padding_right=8 \
    label.drawing=off --subscribe "now_playing.$control" now_playing_change mouse.clicked
done
sketchybar --add bracket now_playing_bracket now_playing now_playing.sep \
  now_playing.prev now_playing.toggle now_playing.next
pill now_playing_bracket
