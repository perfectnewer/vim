" https://vimawesome.com/   vim plugins site
"
" support plugin version(tagm branch...), post hook, args etc
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align

" Any valid git URL is allowed
" Plug 'altercation/vim-colors-solarized'
Plug 'iCyMind/NeoSolarized'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Plugin 'Shougo/neosnippet.vim'
" Plugin 'Shougo/neosnippet-snippets'

" Plug 'junegunn/vim-easy-align'
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'Xuyuanp/nerdtree-git-plugin'

" Plug 'junegunn/fzf', { 'do': '{ -> fzf#install() }' }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
" https://github.com/iamcco/markdown-preview.nvim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'majutsushi/tagbar'
Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'airblade/vim-gitgutter'
"  https://github.com/preservim/nerdcommenter
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdcommenter'

" https://github.com/neoclide/coc-python
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go'
" Plug 'numirias/semshi',   {'do': ':UpdateRemotePlugins'}
" Plug 'plasticboy/vim-markdown'
" Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine',        {'for': ['python', 'go']}
" Plug 'tmhedberg/SimpylFold'
Plug 'ashfinal/vim-colors-violet'

" need 5.0 +
Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
Plug 'kkharji/lspsaga.nvim', { 'branch': 'main' }  " = 'nvim6.0' or 'nvim51' } -- for specific version

" main one
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" 9000+ Snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
" lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
" Need to **configure separately**
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
" Plug 'hrsh7th/nvim-cmp'


Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
" Plug 'yamatsum/nvim-nonicons'
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" disable plugin
" ncm2
Plug 'godlygeek/tabular'
Plug 'vim-scripts/DrawIt'
" Plug 'luochen1990/rainbow'
Plug 'p00f/nvim-ts-rainbow'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'rcarriga/nvim-notify'

Plug 'nvim-lua/plenary.nvim'
Plug 'windwp/nvim-spectre'


call plug#end()
