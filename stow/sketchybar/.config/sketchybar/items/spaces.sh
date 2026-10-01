#!/bin/bash
sketchybar --add event aerospace_workspace_change
sketchybar --add item apple left --set apple icon='' icon.color="$TEXT" \
  icon.font="$FONT:Regular:17.0" icon.width=30 icon.align=center \
  icon.padding_left=10 icon.padding_right=2 label.drawing=off \
  click_script="open -a 'Activity Monitor'"
sketchybar --add item apple_sep left --set apple_sep icon.drawing=off \
  label='|' label.color="$SURFACE" label.padding_left=2 label.padding_right=2

for monitor in $(aerospace list-monitors --format '%{monitor-id}' 2>/dev/null); do
  while IFS= read -r sid; do
    [ -n "$sid" ] || continue
    sketchybar --add item "space.$sid" left --set "space.$sid" \
      display="$monitor" icon="$sid" icon.width=30 icon.align=center \
      icon.color="$MUTED" label.drawing=off background.height=22 \
      background.corner_radius=8 background.color="$YELLOW" \
      click_script="aerospace workspace '$sid'"
  done < <(aerospace list-workspaces --monitor "$monitor" 2>/dev/null)
done
sketchybar --add item workspace_end left --set workspace_end width=8 \
  icon.drawing=off label.drawing=off background.drawing=off
sketchybar --add bracket spaces apple apple_sep '/space\..*/' workspace_end
pill spaces
sketchybar --set spaces background.padding_left=0 background.padding_right=0

# Retry after login if AeroSpace starts after SketchyBar; also refresh selection.
sketchybar --add item workspace_sync left --set workspace_sync \
  drawing=off updates=on update_freq=10 script="$PLUGIN_DIR/workspaces.sh" \
  --subscribe workspace_sync aerospace_workspace_change display_change system_woke
