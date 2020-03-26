" support plugin version(tagm branch...), post hook, args etc
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align

" Any valid git URL is allowed
Plug 'altercation/vim-colors-solarized'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'junegunn/fzf', { 'do': '{ -> fzf#install() }' }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'majutsushi/tagbar'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'airblade/vim-gitgutter'
"  https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'
Plug 'neomake/neomake',   {'for': 'disable'}
Plug 'tpope/vim-fugitive'

" https://github.com/neoclide/coc-python
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'numirias/semshi',   {'do': ':UpdateRemotePlugins', 'for': 'python'}
Plug 'plasticboy/vim-markdown'

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" disable plugin
" ncm2
" python语法代码高亮

Plug 'godlygeek/tabular',        {'for': 'disable'}

call plug#end()

