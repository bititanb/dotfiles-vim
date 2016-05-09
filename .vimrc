""""""""""""""""""""""""""""""""""""""""
" Vundle initialization
""""""""""""""""""""""""""""""""""""""""
set shell=bash          " posix shell needed for vundle
set filetype=off           "  vundle needed
set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required

Plugin 'morhetz/gruvbox'

if has('nvim')
    "Plugin 'klen/python-mode'
    "Plugin 'davidhalter/jedi-vim'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'scrooloose/syntastic'
    Plugin 'vim-utils/vim-husk'
    Plugin 'python-rope/ropevim'
    Plugin 'hynek/vim-python-pep8-indent'
endif

" All of your Plugins must be added before this line
call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS
""""""""""""""""""""""""""""""""""""""""

function! GetFileDirectory ()
    " get directory of opened file for statusline
    let fileDirectory = expand("%:p:h")
    return fileDirectory
endfunction

func! DeleteTrailingWS()
    " delete trailing spaces on save
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

""""""""""""""""""""""""""""""""""""""""
" Vim settings
""""""""""""""""""""""""""""""""""""""""

" no lag in terminal vim
set ttimeoutlen=0

" backups, etc..
set undofile
set undodir=~/.vim/misc
set backup
set backupdir=~/.vim/misc
set directory=~/.vim/misc

" tabs/spaces, indentation
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4
set expandtab       " tabs are spaces
set smarttab            " Be smart when using tabs ;)
set autoindent
set cindent

" statusline
set statusline=%t%<%m%H%W%q%=%{GetFileDirectory()}\ %l-%L\ %p%%
set laststatus=2        " always show status bar

" search, highlighting
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set foldcolumn=1        " Add a bit extra margin to the left

set scrolloff=999
set autoread            " autoreload buffer if changes
set lazyredraw          " redraw only when we need to.
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set ffs=unix,dos,mac
set showfulltag
set hidden              " buffers don't close
set nocompatible        " nocompatible with vi
set colorcolumn=80
set viminfo='50,<100,s100,:1000,/1000,@1000,f1,h
set shiftround
set sessionoptions-=blank

set omnifunc=syntaxcomplete#Complete

setlocal shortmess+=I   " hide intro message on start
" cyrillic support
" set keymap=russian-jcukenwin
" set iminsert=0
" set imsearch=0

autocmd FileType * syntax on
autocmd FileType * setlocal formatoptions-=t
autocmd FileType * setlocal formatoptions-=o
" maximum history items
autocmd FileType * setlocal history=300
autocmd BufWrite * call DeleteTrailingWS()

" mouse support
if has('mouse')
  set mouse=a
endif

""""""""""""""""""""""""""""""""""""""""
" MAPPINGS (keys, bindings)
""""""""""""""""""""""""""""""""""""""""

" :W save the file as root
command W w !sudo tee % > /dev/null

if has('nvim')
    " leave ins mode in :term easier
    tnoremap <C-[> <C-\><C-n>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DEPEND ON $TERM SETTINGS (graphical, gui, gvim, terminal, console, tty)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_running")
    colorscheme gruvbox
    set background=dark
    set guifont=Hack\ 10
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guioptions+=a  "highlighted text automatically copies to "* register
    set guioptions+=c  "no graphical popup dialogs
else
    if $KONSOLE_PROFILE_NAME != '' || $COLORTERM == 'gnome-terminal' ||
                \ $TERM == 'screen' || $TERM == 'screen-256color' ||
                \ $TERM == 'xterm-256color'
        try
            colorscheme gruvbox
        catch
        endtry

        set background=dark
    else
        colorscheme desert
        set background=dark
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
    " python-mode
    "let g:pymode_lint_cwindow = 0
    "let g:pymode_rope_completion = 0
    "let g:pymode_folding = 0

    " jedi-vim
    "let g:jedi#popup_on_doeed_identifiers_with_syntax = 1

    " youcompleteme
    "let g:ycm_seed_identifiers_with_syntax = 1
    "let g:ycm_server_keep_logfiles = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_key_list_select_completion = ['<Down>', 'CTRL-N']
    let g:ycm_key_list_previous_completion = ['<Up>', 'CTRL-P']
    nmap <leader>d :YcmCompleter GoToDeclaration<CR>
    nmap <leader>D :YcmCompleter GoToDefinition<CR>
    nmap <leader>* :YcmCompleter GoToReferences<CR>
    nmap <leader>k :YcmCompleter GetDoc<CR>

    " ultisnips
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"

    " syntastic
    "let g:syntastic_always_populate_loc_list = 1
    "let g:syntastic_auto_loc_list = 1
    "let g:syntastic_check_on_open = 1
    "let g:syntastic_check_on_wq = 0
    "let g:syntastic_error_symbol = 'E'
    "let g:syntastic_warning_symbol = 'W'
    "let g:syntastic_style_error_symbol = 'e'
    "let g:syntastic_style_warning_symbol = 'w'
    "let g:syntastic_python_python_use_codec = 1
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_python_checkers = ["python", "pyflakes", "pep8"]

    " ropevim
    "let ropevim_extended_complete = 1
    "let g:ropevim_autoimport_modules = ["os.*", "sys"]
endif
