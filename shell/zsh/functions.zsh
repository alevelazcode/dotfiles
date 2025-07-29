# Functions equivalent to Fish's abbreviation
function bd() { exit }
function q() { tmux kill-server }
function ast() { aw set -t $(aw list | fzf-tmux -p --reverse --preview 'aw set -t {}') }

function pn() { pnpm }
function pni() { pnpm i }
function pnd() { pnpm dev }
function pbs() { pnpm serve }
function pnb() { pnpm build }

function ns() { npm run serve }

function c() { clear }
function cx() { chmod +x }
function dc() { docker compose }
function dcd() { docker compose down }
function dcdv() { docker compose down -v }
function dcr() { docker compose restart }
function dcu() { docker compose up -d }

copy() {
    printf "%s" "$*" | tr -d "\n" | pbcopy
}



