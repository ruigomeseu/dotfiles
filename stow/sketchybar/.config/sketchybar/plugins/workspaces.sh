#!/bin/bash
# One refresh for the whole workspace group; also handles login startup order.
export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
/usr/bin/python3 <<'PY'
import json
import subprocess

def read(*args):
    return subprocess.check_output(args, text=True, stderr=subprocess.DEVNULL, timeout=3)

try:
    workspaces = read('aerospace', 'list-workspaces', '--all').splitlines()
    focused = read('aerospace', 'list-workspaces', '--focused').strip()
    occupied = {w['workspace'] for w in json.loads(read('aerospace', 'list-windows', '--all', '--json', '--format', '%{workspace}'))}
    bar = json.loads(read('sketchybar', '--query', 'bar'))
except (subprocess.SubprocessError, ValueError):
    raise SystemExit(0)

existing = {name.removeprefix('space.') for name in bar['items'] if name.startswith('space.')}
if existing != set(workspaces):
    subprocess.run(['sketchybar', '--reload'], check=True)
    raise SystemExit(0)

args = ['sketchybar']
for sid in workspaces:
    selected = sid == focused
    # Keep the numbered row; show named workspaces when occupied or focused.
    visible = sid.isdecimal() or sid in occupied or selected
    args += ['--set', 'space.' + sid, 'drawing=' + ('on' if visible else 'off'),
             'icon.color=' + ('0xff181926' if selected else '0xff8087a2'),
             'background.drawing=' + ('on' if selected else 'off')]
subprocess.run(args, check=True)
PY
