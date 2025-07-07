#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor "$m"); do
    sid=$i

    space=(
      space="$sid"

      display="$m"

      label="$sid"
      label.color="$FLAMINGO"
      background.color="$FLAMINGO_BG"

      padding_left=2
      padding_right=2

      script="$PLUGIN_DIR/space.sh $sid"
      click_script="aerospace workspace $sid"
    )

    sketchybar --add space "space.$sid" left \
      --set "space.$sid" "${space[@]}" \
      --subscribe "space.$sid" aerospace_workspace_change
  done
done
