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
" Plug 'iCyMind/NeoSolarized'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/fzf', { 'do': '{ -> fzf#install() }' }
Plug 'junegunn/fzf.vim'
" https://github.com/iamcco/markdown-preview.nvim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'majutsushi/tagbar'
Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'airblade/vim-gitgutter'
"  https://github.com/preservim/nerdcommenter
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdcommenter'

" https://github.com/neoclide/coc-python
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
Plug 'fatih/vim-go'
" Plug 'numirias/semshi',   {'do': ':UpdateRemotePlugins'}
" Plug 'plasticboy/vim-markdown'
" Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine',        {'for': ['python', 'go']}
Plug 'tmhedberg/SimpylFold'
Plug 'ashfinal/vim-colors-violet'

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" disable plugin
" ncm2
Plug 'godlygeek/tabular',        {'for': 'disable'}
Plug 'vim-scripts/DrawIt'

call plug#end()
