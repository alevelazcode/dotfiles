#!/usr/bin/env bash
# workspaces.sh — app -> space assignments (SRP: window routing only)

# 1  terminal
yabai -m rule --add app="^WezTerm$"         space=^1
# 2  Zen browser
yabai -m rule --add app="^Zen$"             space=^2
# 3  Safari
yabai -m rule --add app="^Safari$"          space=^3
# 4  music
yabai -m rule --add app="^Spotify$"         space=^4
# 5  work chat
yabai -m rule --add app="^Slack$"           space=^5
yabai -m rule --add app="^Microsoft Teams$" space=^5
# 6  containers
yabai -m rule --add app="^Docker Desktop$"  space=^6
# 7  database
yabai -m rule --add app="^MongoDB Compass$" space=^7
# 8  vpn
yabai -m rule --add app="^NordVPN$"         space=^8
# 9  personal chat
yabai -m rule --add app="^Telegram$"        space=^9
yabai -m rule --add app="^WhatsApp$"        space=^9
