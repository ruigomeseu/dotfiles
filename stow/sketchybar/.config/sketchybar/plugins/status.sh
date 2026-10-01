#!/bin/bash
source "$CONFIG_DIR/colors.sh"

case "$NAME" in
  battery)
    batt=$(pmset -g batt)
    percent=$(printf '%s\n' "$batt" | awk 'match($0, /[0-9]+%/) {print substr($0, RSTART, RLENGTH-1); exit}')
    if [ -z "$percent" ]; then
      sketchybar --set "$NAME" drawing=off --set gap_battery_time width=0
      exit 0
    fi
    color=$SKY
    case "$percent" in
      100|[8-9][0-9]) icon='';;
      [6-7][0-9]) icon='';;
      [4-5][0-9]) icon='';;
      [2-3][0-9]) icon='';;
      *) icon=''; color=$RED;;
    esac
    if [[ "$batt" == *charging* && "$batt" != *discharging* ]]; then
      icon=''; color=$YELLOW
    fi
    sketchybar --set "$NAME" drawing=on icon="$icon" icon.color="$color" label="${percent}%" \
      --set gap_battery_time width=8
    ;;
  time) sketchybar --set "$NAME" label="$(date '+%I:%M %p')";;
  date) sketchybar --set "$NAME" label="$(date '+%d %b %a')";;
  cpu)
    cores=$(sysctl -n hw.ncpu)
    percent=$(ps -A -o %cpu= | LC_ALL=C awk -v n="$cores" '{sum += $1} END {printf "%.1f", sum/n}')
    sketchybar --set "$NAME" label="${percent}%"
    ;;
  memory)
    # App + wired + physically compressed memory, excluding reclaimable cache.
    total=$(sysctl -n hw.memsize)
    pageable=$(sysctl -n vm.page_pageable_internal_count 2>/dev/null)
    label=$(vm_stat | LC_ALL=C awk -v total="$total" -v pageable="$pageable" '
      NR == 1 {match($0, /[0-9]+/); size=substr($0, RSTART, RLENGTH)}
      /Pages wired down:/ {wired=$NF+0}
      /Pages occupied by compressor:|Pages used by compressor:/ {compressed=$NF+0}
      /Pages purgeable:/ {purgeable=$NF+0}
      /Anonymous pages:/ {anon=$NF+0}
      END {
        if (pageable == "") pageable=anon
        app=pageable-purgeable; if (app<0) app=0
        used=(app+wired+compressed)*size
        printf "%d%% | %.1fG", used*100/total, used/1073741824
      }')
    sketchybar --set "$NAME" label="$label"
    ;;
  temp)
    temp=$("$CONFIG_DIR/helpers/mac-temp" 2>/dev/null | LC_ALL=C awk '
      /tdie/ {value=$NF; gsub(/[^0-9.]/, "", value); if (value+0>=10) last[$1" "$2]=value+0}
      END {for (key in last) {sum+=last[key]; n++} if (n) printf "%.0f", sum/n}')
    if [ -n "$temp" ]; then
      color=$SKY
      if [ "$temp" -ge 85 ]; then color=$RED
      elif [ "$temp" -ge 75 ]; then color=$YELLOW; fi
      sketchybar --set "$NAME" label="${temp}°C" icon.color="$color"
    else
      sketchybar --set "$NAME" label='--°C'
    fi
    ;;
esac
