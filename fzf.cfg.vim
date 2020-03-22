" doc https://github.com/junegunn/fzf#installation
"

" install by brew
set rtp+=/usr/local/opt/fzf

" https://github.com/junegunn/fzf.vim
map <C-p> :Files<CR>
map <leader>p :GFiles?<CR>
map <leader>b :Buffers<CR>
map <leader>g :GFiles<CR>
