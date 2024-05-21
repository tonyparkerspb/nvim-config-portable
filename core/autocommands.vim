" Load auto-command defined in Lua
lua require("custom-autocmd")

" Quit Nvim if we have only one window, and its filetype match our pattern.
" augroup auto_close_win
"   autocmd!
"   autocmd BufEnter * call s:quit_current_win()
" augroup END
"
" function! s:quit_current_win() abort
"   let l:quit_filetypes = ['qf', 'vista', 'NvimTree']
"
"   let l:should_quit = v:true
"
"   let l:tabwins = nvim_tabpage_list_wins(0)
"   for w in l:tabwins
"     let l:buf = nvim_win_get_buf(w)
"     let l:bf = getbufvar(l:buf, '&filetype')
"
"     if index(l:quit_filetypes, l:bf) == -1
"       let l:should_quit = v:false
"     endif
"   endfor
"
"   if l:should_quit
"     qall
"   endif
" endfunction

" ref: https://vi.stackexchange.com/a/169/15292
function! s:handle_large_file() abort
  let g:large_file = 10485760 " 10MB
  let f = expand("<afile>")

  if getfsize(f) > g:large_file || getfsize(f) == -2
    set eventignore+=all
    " turning off relative number helps a lot
    set norelativenumber
    setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1
  else
    set eventignore-=all relativenumber
  endif
endfunction

augroup LargeFile
  autocmd!
  autocmd BufReadPre * call s:handle_large_file()
augroup END

function! s:toggle_indent_lines() abort
  let l:no_indent_filetypes = ['dashboard']

  if index(l:no_indent_filetypes, &filetype) == -1
    IndentLinesEnable 
  else
    IndentLinesDisable
  endif
endfunction

" augroup IndentLines
"   autocmd!
"   autocmd BufReadPre * call s:toggle_indent_lines()
" augroup END

" neoformat
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :FormatWrite
