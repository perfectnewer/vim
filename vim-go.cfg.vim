" 补全使用 https://github.com/deoplete-plugins/deoplete-go.git
" 依赖于 https://github.com/Shougo/deoplete.nvim
" " 依赖 pynvim

let g:UltiSnipsExpandTrigger = "<tab>"

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go setlocal noexpandtab |  setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal tabstop=4
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>gt :GoDeclsDir<cr>
autocmd Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
autocmd Filetype go nmap <leader>gah <Plug>(go-alternate-split)
autocmd Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
autocmd FileType go nmap <F10> :GoTest -short<cr>
autocmd FileType go nmap <F9> :GoCoverageToggle -short<cr>
autocmd FileType go nmap <F12> <Plug>(go-def)

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1

let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_list_type = "quickfix"
let g:go_addtags_transform = "snakecase"
let g:go_snippet_engine = "neosnippet"
