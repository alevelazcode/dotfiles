source $HOME/.config/nvim/general.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/theme.vim
source $HOME/.config/nvim/map.vim
source $HOME/.config/nvim/plug-config.vim
source $HOME/.config/nvim/leader.vim

source $HOME/.config/nvim/config.lua
source $HOME/.config/nvim/treesitter.lua
source $HOME/.config/nvim/lualine.lua
source $HOME/.config/nvim/alpha.lua
source $HOME/.config/nvim/coc.vim

" Miscellaneous
let g:python3_host_prog='/opt/homebrew/bin/python3'

let g:airline#extensions#tabline#enabled=1
let g:vim_markdown_folding_disabled = 1

let g:rooter_patterns = ['.git']


" Write all buffers before navigating from Vim to tmux pane
"let g:tmux_navigator_save_on_switch = 2
