autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType go nmap <leader>gt :GoDeclsDir<cr>
autocmd FileType go nmap <F12> <Plug>(go-def)
autocmd FileType go set foldlevelstart=0

""" vim-go
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 0
let g:go_highlight_operators = 0
let g:go_fmt_experimental = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1

let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"  " 自动import
let g:go_addtags_transform = "snakecase"
let g:go_snippet_engine = "neosnippet"

"  "  Error and warning signs.
"  let g:ale_sign_error = '⤫'
"  let g:ale_sign_warning = '⚠'
"  " Enable integration with airline.
"  let g:airline#extensions#ale#enabled = 1

