scriptencoding utf-8

set number relativenumber  " Show line number and relative line number

" syntax highlight
syntax enable
hi Normal guibg=NONE ctermbg=NONE " transparent background

" russian language support
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
" highlight lCursor guifg=NONE guibg=Cyan - not working
setlocal spell spelllang=ru_yo,en_us " support of 'ё' letter
" to avoid problems in normal mode when switching language in system settings
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Clipboard settings, always use clipboard for all delete, yank, change, put
" operation, see https://stackoverflow.com/q/30691466/6064933
if !empty(provider#clipboard#Executable())
  set clipboard+=unnamedplus
endif

" Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
set noswapfile

" Ignore certain files and folders when globing
set wildignore+=*.o,*.obj,*.dylib,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc,*.pkl
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv
set wildignorecase  " ignore file and dir name cases in cmd-completion

" Set up backup directory
let g:backupdir=expand(stdpath('data') . '/backup//')
let &backupdir=g:backupdir

" Skip backup for patterns in option wildignore
let &backupskip=&wildignore
set backup  " create backup for files
set backupcopy=yes  " copy the original file to backupdir and overwrite it

" General tab settings
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

set cindent

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」,『:』,【:】,“:”,‘:’,《:》

" File and script encoding settings for vim
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" Break line at predefined characters
set linebreak
" Character to show before the lines that have been soft-wrapped
set showbreak=↪

" Disable showing current mode on command line since statusline plugins can show it.
" set noshowmode

" Ask for confirmation when handling unsaved or read-only files
set confirm

set visualbell noerrorbells  " Do not use visual and errorbells
set history=500  " The number of command and search history to keep

" Persistent undo even after you close a file and re-open it
set undofile

set virtualedit=block  " Virtual edit is useful for visual block edit

set winblend=0  " pseudo transparency for floating window

" Insert mode key word completion setting
set complete+=kspell complete-=w complete-=b complete-=u complete-=t

set spelllang=en,cjk  " Spell languages
set spellsuggest+=9  " show 9 spell suggestions at most

set synmaxcol=250  " Text after this column number is not highlighted
set nostartofline

" Enable true color support. Do not set this option if your terminal does not
" support true colors! For a comprehensive list of terminals supporting true
" colors, see https://github.com/termstandard/colors and https://gist.github.com/XVilka/8346728.
set termguicolors

set background=light
colorscheme solarized

" Set up cursor color and shape in various mode, ref:
" https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-color-in-the-terminal
" set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20 - not working

set nowrap  " do no wrap
set noruler

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

" Disable showing current mode on command line since statusline plugins can show it.
set noshowmode

" Use mouse to select and resize windows, etc.
" set mouse=nic  " Enable mouse in several mode
" set mousemodel=popup  " Set the behaviour of mouse
" set mousescroll=ver:1,hor:6

" TODO: move this mapping to lua
" nnoremap <A-LeftMouse> <Cmd>
"       \ set mouse=<Bar>
"       \ echo 'mouse OFF until next cursor-move'<Bar>
"       \ autocmd CursorMoved * ++once set mouse&<Bar>
"       \ echo 'mouse ON'<CR>
"

" TODO: rewrite this mapping to lua
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" let loaded_netrw=1
" let loaded_netrwPlugin=1

" let g:indentLine_char_list = ['|']
" let g:indentLine_setColors = 0
" let g:indentLine_enabled = 0

" set cursorcolumn
set cursorline

let g:better_escape_shortcut = ['jj', 'оо']

" replace word under cursor
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" search word under cursor
vnoremap <C-f> "fy/<C-r>f<CR>

" correct indentation for braces
" inoremap {<CR> {<CR>}<Esc>O<BS><Tab>
" inoremap [<CR> [<CR>]<Esc>O<BS><Tab>
" inoremap (<CR> (<CR>)<Esc>O<BS><Tab>

" line text object
xnoremap il g_o0
onoremap il :normal vil<CR>
xnoremap al $o0
onoremap al :normal val<CR>

" leave only this window (:only)
" nnoremap <leader>o :only<CR>
