scriptencoding utf-8

" Plugin specification and lua stuff
lua require('plugins')


"""""""""""""""""""""""""UltiSnips settings"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use YouCompleteMe
let g:UltiSnipsExpandTrigger='<c-j>'

" Do not look for SnipMate snippets
let g:UltiSnipsEnableSnipMate = 0

" Shortcut to jump forward and backward in tabstop positions
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" Configuration for custom snippets directory, see
" https://jdhao.github.io/2019/04/17/neovim_snippet_s1/ for details.
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'my_snippets']


"""""""""""""""""""""""""""""" neoformat settings """""""""""""""""""""""
" let g:neoformat_typescript_eslint = {
"       \ 'exe': 'prettier-eslint',
"       \ 'args': ['--stdin'],
"       \ 'stdin': 1, 
"       \ }
"
" let g:neoformat_try_node_exe = 1
" let g:neoformat_enabled_python = ['autopep8']
" let g:neoformat_enabled_javascript = ['prettier']
" let g:neoformat_enabled_typescript = ['eslint']
" let g:neoformat_enabled_vue = ['prettier-eslint']
" let g:neoformat_enabled_lua = ['stylua']

