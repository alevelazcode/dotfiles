call plug#begin()
  "GIt

  Plug 'ap/vim-css-color'
  Plug 'iamcco/markdown-preview.nvim'
  Plug 'alvan/vim-closetag'
  Plug 'gregsexton/MatchTag'
  "Plug 'mattn/Emmet-vim'
  Plug 'psliwka/vim-smoothie'
  
  "Search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'justinmk/vim-sneak'

  Plug 'junegunn/goyo.vim'

  Plug 'phaazon/hop.nvim'

  Plug 'tpope/vim-surround'
  Plug 'leafOfTree/vim-vue-plugin' 

  "shorcuts html
  Plug 'mattn/emmet-vim'

  "Coc autocomplete
  " Plug 'SirVer/ultisnips'

  Plug 'neoclide/coc.nvim', {'branch': 'release'} 
  Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-sources', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
  Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
  Plug 'felippepuhle/coc-graphql', {'do': 'yarn install --frozen-lockfile'}


  Plug 'neovim/nvim-lspconfig'
  Plug 'sheerun/vim-polyglot'
  Plug 'windwp/nvim-autopairs'
  Plug 'jparise/vim-graphql'

  Plug 'fatih/vim-go'
"
  "git
  " the hidden message from Git under the cursor quickly. It shows the history of commits under the cursor in popup window.
  Plug 'rhysd/git-messenger.vim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'itchyny/vim-gitbranch'

  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

  "Theme
  Plug 'xiyaowong/nvim-transparent'
  Plug 'catppuccin/nvim', {'as': 'catppuccin'}
  Plug 'norcalli/nvim-colorizer.lua'

  "Icons
  Plug 'kyazdani42/nvim-web-devicons'

  "Comments
  Plug 'numToStr/Comment.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'ThePrimeagen/harpoon'
  
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  "indent
  Plug 'lukas-reineke/indent-blankline.nvim'

  "fix format
  Plug 'dense-analysis/ale'

  "Rust
  Plug 'rust-lang/rust.vim'
  
  " Navigation
  Plug 'kyazdani42/nvim-tree.lua'

  "Greteer
  Plug 'goolord/alpha-nvim'


  Plug 'folke/todo-comments.nvim'
  " Plug 'github/copilot.vim'
  Plug 'godlygeek/tabular'

  Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
call plug#end()
