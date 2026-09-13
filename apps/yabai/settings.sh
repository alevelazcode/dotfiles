#!/usr/bin/env bash
# settings.sh — window manager layout config (SRP: tiling behavior only)

# tile all windows using binary space partitioning
yabai -m config layout bsp

# new window spawns right (vertical split) or bottom (horizontal split)
yabai -m config window_placement second_child

# padding + gaps
yabai -m config top_padding    12
yabai -m config bottom_padding 12
yabai -m config left_padding   12
yabai -m config right_padding  12
yabai -m config window_gap     12
