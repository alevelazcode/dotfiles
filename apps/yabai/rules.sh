#!/usr/bin/env bash
# rules.sh — windows excluded from tiling (SRP: unmanaged apps only)

yabai -m rule --add app="^System Settings$"    manage=off
yabai -m rule --add app="^Calculator$"         manage=off
yabai -m rule --add app="^Karabiner-Elements$" manage=off
