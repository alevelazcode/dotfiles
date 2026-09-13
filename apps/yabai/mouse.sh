#!/usr/bin/env bash
# mouse.sh — mouse interaction config (SRP: pointer behavior only)

# focus follows mouse pointer
yabai -m config mouse_follows_focus on

# hold ctrl to drag windows
yabai -m config mouse_modifier ctrl

# ctrl + left-click drag  -> move window
yabai -m config mouse_action1 move
# ctrl + right-click drag -> resize window
yabai -m config mouse_action2 resize

# drop a window onto another -> swap them
yabai -m config mouse_drop_action swap
