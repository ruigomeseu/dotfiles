#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '[0-9]+%' | tr -d '%')"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
[3-9][0-9] | 100)
  COLOR=$BATTERY
  ;;
[1-2][0-9])
  COLOR=$BATTERY_WARNING
  ;;
[0-9])
  COLOR=$BATTERY_CRITICAL
  ;;
esac

OUTPUT="${PERCENTAGE}%"

if [[ "$CHARGING" != "" ]]; then
  OUTPUT="${PERCENTAGE}^"
fi

sketchybar --set "$NAME" label="B ⋮ $OUTPUT" "label.color=$COLOR"
