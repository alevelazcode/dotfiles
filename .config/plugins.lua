local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)

  use 'wbthomason/packer.nvim'
  -- Your plugins go here
  --
  --
  use 'iamcco/markdown-preview.nvim'
  use 'gregsexton/MatchTag'
  use 'olimorris/persisted.nvim' 



  use 'phaazon/hop.nvim'

  use 'tpope/vim-surround'
  use 'leafOfTree/vim-vue-plugin' 

  "shorcuts html
  use 'mattn/emmet-vim'


  "Theme
  use 'xiyaowong/nvim-transparent'
  use { "catppuccin/nvim", as= "catppuccin" }
  use 'norcalli/nvim-colorizer.lua'

  "Icons
  use 'kyazdani42/nvim-web-devicons'

  "Comments
  use 'numToStr/Comment.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'ThePrimeagen/harpoon'
  
  use { 'nvim-treesitter/nvim-treesitter', do= ':TSUpdate' }

  "indent
  use 'lukas-reineke/indent-blankline.nvim'

  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  use 'lewis6991/gitsigns.nvim'
  "use 'tpope/vim-fugitive'
  use {
  'dinhhuy258/git.nvim'
  }
  -- using packer.nvim
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  " Navigation
  use 'kyazdani42/nvim-tree.lua'

  "Greteer
  use 'goolord/alpha-nvim'



  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'neovim/nvim-lspconfig' -- LSP
  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua

  use 'williamboman/mason-lspconfig.nvim'

  use 'glepnir/lspsaga.nvim' -- LSP UIs
  use 'L3MON4D3/LuaSnip'se 'MunifTanjim/prettier.nvim' -- Prettier plugin for Neovim's built-in LSP client use'neovim/nvim-lspconfig'


end)
