set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=aFc
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

let g:coc_global_extensions=['coc-snippets', 'coc-vimlsp', 'coc-git',
	\ 'coc-lists', 'coc-explorer', 'coc-pairs', 'coc-pyright']  " 'coc-bookmark', 'coc-jedi',

" config for coc-settings

if g:system_py_version == 2
    let s:pyneovim_path = g:pyenv_py2_prefix

    call coc#config('languageserver.python.command', s:pyneovim_path . '/bin/python')
    call coc#config('pyright.enable', v:false)
else
    let s:pyneovim_path = g:pyenv_py3_prefix

    call coc#config('languageserver.python.filetypes', [])
endif

call coc#config('python', {
    \ 'venvPath	': g:pyenv_root . '/versions',
    \ 'setLinter': 'flake8',
    \ 'linting.flake8Path': s:pyneovim_path . '/bin/flake8',
    \ 'linting.flake8Enabled': v:true,
    \ 'linting.flake8Args': ['max-line-length = 120', 'ignore = E226,E302,E41,W391'],
    \ 'linting.pylintPath': s:pyneovim_path . '/bin/pylint',
    \ 'linting.pylintEnabled': v:true,
    \})

let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:activate_this = join(readfile(s:curdir . '/activate_env.py', "b"), "\n")
call coc#config('python.linting.pylintArgs', ['--init-hook', s:activate_this])
" call coc#config('python.linting.pylintArgs', ['--init-hook', 'import pylint_venv; pylint_venv.inithook(force_venv_activation=True)'])

   " \ 'jediPath': s:pyneovim_path . '/lib/python3.7/site-packages/jedi',

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <c-space>for trigger completion
" inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" To make snippet completion work just like VSCode, you need to install coc-snippets then configure your <tab> in vim like:
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" 
" And add:
"   // make vim select first item on completion
"   "suggest.noselect": false
" to your coc-settings.json.

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" To make coc.nvim format your code on <cr>, use keymap:
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : 
                                           \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
let g:coc_snippet_next = '<tab>'

" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> ge :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Explorer
nnoremap <silent> <space>e  :CocCommand explorer<CR>
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Show commands.
nnoremap <space>c  :CocList 
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
nnoremap <silent> <space>g  :<C-u>CocList --normal gstatus<CR>
nnoremap <space>r :<C-u>CocCommand python.execInTerminal<CR>
nnoremap <space>rp :<C-u>tabnew term://zsh<CR>:<C-u>CocCommand python.startREPL<CR>

" coc bookmark
nmap <Leader>bj <Plug>(coc-bookmark-next)
nmap <Leader>bk <Plug>(coc-bookmark-prev)
nmap <Leader>bt <Plug>(coc-bookmark-toggle)
nmap <Leader>ba <Plug>(coc-bookmark-annotate)
