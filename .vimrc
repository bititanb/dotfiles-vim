""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS
""""""""""""""""""""""""""""""""""""""""

function! GetFileDirectory ()
  " get directory of opened file for statusline
  let fileDirectory = expand('%:p:h')
  return fileDirectory
endfunction

function! DeleteTrailingWS()
  " delete trailing spaces on save
  if &ft =~ 'markdown'
    return
  endif

  execute 'normal mz'
  %s/\s\+$//ge
  execute 'normal `z'
endfunction

let g:unavail#msg#list = []
function! AddUnavailMsg(name)
  let g:unavail#msg#list = add(g:unavail#msg#list, expand(a:name . ' not available.'))
endfunction

let g:msg#list = []
function! AddMsg(msg)
  let g:msg#list = add(g:msg#list, expand(a:msg))
endfunction

function! IsTerm256Colors()
  if $KONSOLE_PROFILE_NAME !=? '' || $COLORTERM ==? 'gnome-terminal' ||
        \ $TERM ==? 'screen' || $TERM ==? 'screen-256color' ||
        \ $TERM ==? 'xterm-256color'
    return 1
  endif
endfunction

function! SendMessages()
  " WORKAROUND with autocmd for gvim popping up dialog box
  if g:unavail#msg#list != []
    let g:unavail#msg = join(g:unavail#msg#list)
    autocmd VimEnter * echomsg g:unavail#msg
  endif
  if g:msg#list != []
    let g:msg = join(g:msg#list)
    autocmd VimEnter * echomsg g:msg
  endif
endfunction

function! IsFeatAvail(feature, msg)
  if has(a:feature)
    return 1
  endif

  call AddUnavailMsg(a:msg)
endfunction

function! IsPlugManInst()
  if filereadable(g:path#plug_man_exec)
    return 1
  endif

  call AddUnavailMsg('Plugin manager')
endfunction

function! DownloadFile(url, path)
  silent! execute '!curl -fLo "' . a:path . '" --create-dirs "' . a:url . '"'

  if filereadable(a:path)
    return 1
  endif
endfunction

function! GetPlugMan()
  call EnsureDirExist(g:path#autoload)
  let g:uri#plug_man = 'https://raw.githubusercontent.com/junegunn/
        \vim-plug/master/plug.vim'
  if DownloadFile(g:uri#plug_man, g:path#plug_man_exec)
    call AddMsg('Plugin manager installed.')
    autocmd VimEnter * call PromptExecute('PlugInstall')
  else
    call AddMsg('Plugin manager failed to install.')
  endif
endfunction

function! DelNewLines(text)
  let g:delnewlines#result = substitute(a:text, "\n", "", "g")
  return g:delnewlines#result
endfunction

function! EnsureDirExist(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

function! IsPipInstalled()
  call system('pip --version')
  if v:shell_error ==? 0
    return 1
  endif

  call AddUnavailMsg('Pip-dependent plugins')
endfunction

function! GetSyntasticCheckers(info)
  if a:info.status ==? 'installed' || a:info.status ==? 'updated' ||
        \ a:info.force

    call system('pip install --user pyflakes')
    call system('pip install --user pep8')
    call system('pip install --user vim-vint')
  endif
endfunction

function! PromptExecute(cmd)
  if input('Execute ' . a:cmd . ' ? Type y or n.   ') ==? 'y'
    execute a:cmd
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""
" VARS
""""""""""""""""""""""""""""""""""""""""

if has('nvim')
  let g:path#vim_user_dir = expand('~/.config/nvim')
  let g:path#vimrc = expand('~/.config/nvim/init.vim')
else
  let g:path#vim_user_dir = expand('~/.vim')
  let g:path#vimrc = expand('~/.vimrc')
endif


let g:path#autoload = expand(g:path#vim_user_dir . '/autoload')
let g:path#plug_man_exec = expand(g:path#vim_user_dir . '/autoload/plug.vim')
let g:path#plug_man_dir = expand(g:path#vim_user_dir . '/plugged')

" let &rtp .= ','.expand(g:path#vim_user_dir . '/ftplugin')
" let &rtp .= ','.expand(g:path#vim_user_dir . '/indent')
" let &rtp .= ','.expand(g:path#vim_user_dir . '/syntax')
let &undodir = expand(g:path#vim_user_dir . '/misc')
let &backupdir = expand(g:path#vim_user_dir . '/misc')
let &directory = expand(g:path#vim_user_dir . '/misc')

for dir in [g:path#vim_user_dir, g:path#plug_man_dir, &undodir, &backupdir, &directory]
  call EnsureDirExist(dir)
endfor

""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""

if !IsPlugManInst()
  call GetPlugMan()
endif

call plug#begin(g:path#plug_man_dir)

" theme
" Plug 'morhetz/gruvbox'
Plug 'bititanb/gruvbox'
let g:gruvbox_contrast_dark='none'
let g:gruvbox_italic=1
Plug 'joshdick/onedark.vim'
let g:onedark_terminal_italics = 1
Plug 'rakr/vim-one'
let g:one_allow_italics = 1
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'KeitaNakamura/neodark.vim'
let g:neodark#terminal_transparent = 1
" Plug 'MaxSt/FlatColor'
Plug 'icymind/NeoSolarized'
let g:neosolarized_italic = 1
Plug 'jacoborus/tender.vim'
function! SetColorScheme(colors, ...)
  " first arg: gui, 256, or tty
  " second optional arg: background (default = dark)

  " colors for :terminal must be set explicitly
  " let g:terminal_color_0  = '#2e3436'
  " let g:terminal_color_1  = '#cc0000'
  " let g:terminal_color_2  = '#4e9a06'
  " let g:terminal_color_3  = '#c4a000'
  " let g:terminal_color_4  = '#3465a4'
  " let g:terminal_color_5  = '#75507b'
  " let g:terminal_color_6  = '#0b939b'
  " let g:terminal_color_7  = '#d3d7cf'
  " let g:terminal_color_8  = '#555753'
  " let g:terminal_color_9  = '#ef2929'
  " let g:terminal_color_10 = '#8ae234'
  " let g:terminal_color_11 = '#fce94f'
  " let g:terminal_color_12 = '#729fcf'
  " let g:terminal_color_13 = '#ad7fa8'
  " let g:terminal_color_14 = '#00f5e9'
  " let g:terminal_color_15 = '#eeeeec'

  if a:colors == '256' || a:colors == 'gui'
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    set termguicolors

    execute 'colorscheme gruvbox'
    " autocmd BufEnter * highlight Normal guibg=0
  elseif a:colors == 'tty'
    execute 'colorscheme desert'
  endif

  if exists('a:1')
    let &background = a:1
  else
    set background=dark
  endif
endfunction


Plug 'scrooloose/syntastic'
let g:syntastic_aggregate_errors = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 3
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
"let g:syntastic_python_checkers = ['python', 'pyflakes', 'pep8']
" let g:syntastic_python_checkers = ['python']
" let g:syntastic_vim_checkers = ['vint']
" let g:syntastic_sh_checkers = ['sh', 'shellcheck']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_spec_checkers = ['']

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<c-tab>'

Plug 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep'
let g:ack_qhandler = "botright copen 3"
let g:ackpreview = 1
nnoremap <leader>s :Ack!<Space>''<Left>

" Plug 'raimondi/delimitmate'
" let delimitMate_matchpairs = '(:),[:],{:},<:>'
" let delimitMate_nesting_quotes = ['"','`',"'"]
" let delimitMate_expand_cr = 1
" let delimitMate_expand_space = 1
" let delimitMate_expand_inside_quotes = 1
" let delimitMate_jump_expansion = 1
" let delimitMate_balance_matchpairs = 1

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutJump = '<s-tab>'

Plug 'majutsushi/tagbar'
let g:tagbar_compact = 1
nnoremap <leader>E :TagbarToggle<CR>
"autocmd FileType python nested :call tagbar#autoopen(0)

if has('nvim')
  Plug 'rbgrouleff/bclose.vim'
endif
Plug 'Shougo/unite.vim'
nnoremap <C-P> :Unite -start-insert -auto-resize buffer file_rec<CR>

" Plug 'Shougo/vimfiler.vim'
" let g:vimfiler_as_default_explorer = 1
" let g:vimfiler_quick_look_command = 'gloobus-preview'
" nnoremap <leader>e :VimFilerExplorer<CR>
" call vimfiler#custom#profile('default', 'context', {
"       \ 'safe' : 0,
"       \ 'preview_action': 'switch',
"       \ })

" Plug 'airodactyl/neovim-ranger'
" Plug 'rbgrouleff/bclose.vim'
Plug 'bititanb/ranger.vim'
let g:ranger_map_keys = 0
" function! RangerOpen()
"   execute 'tabnew'
"   execute 'Ranger'
" endfunction
nmap <leader>e :Ranger<CR>

Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner='|'

"Plug 'sbdchd/neoformat'

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_python_binary_path = 'python2'
nmap <leader>d :YcmCompleter GoToDeclaration<CR>
nmap <leader>D :YcmCompleter GoToDefinition<CR>
nmap <leader>* :YcmCompleter GoToReferences<CR>
nmap <leader>k :YcmCompleter GetDoc<CR>
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \   'python' : ['re!(import\s+|from\s+(\w+\s+(import\s+(\w+,\s+)*)?)?)'],
  \ }
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'lua' : 1
      \}


" readline bindings
Plug 'vim-utils/vim-husk'
Plug 'tpope/vim-surround'
Plug 'moll/vim-bbye'
" Plug 'tomtom/tcomment_vim'
Plug 'will133/vim-dirdiff'
Plug 'tpope/vim-eunuch'
" Plug 'tbastos/vim-lua'
Plug 'roxma/vim-paste-easy'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'andrewradev/splitjoin.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'gioele/vim-autoswap'
" Plug 'yuttie/comfortable-motion.vim'

Plug 'raymond-w-ko/vim-lua-indent'
" Plug 'hail2u/vim-css3-syntax'
" Plug 'othree/html5.vim'
" Plug 'ingydotnet/yaml-vim'
" Plug 'hdima/python-syntax'
" Plug 'hynek/vim-python-pep8-indent'
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['lua']

Plug 'tyru/caw.vim'
let g:caw_hatpos_skip_blank_line = 1
let g:caw_wrap_skip_blank_line = 1

Plug 'Yggdroot/indentLine'
let g:indentLine_char = '┊'

" Plug 'joonty/vdebug', { 'branch': 'v2-integration' }
" if !exists('g:vdebug_options')
"   let g:vdebug_options = {}
" endif
" let g:vdebug_options.port = 8172

" Plug 'idanarye/vim-vebugger'
" let g:vebugger_leader='<Leader>z'

" set shiftwidth automatically
Plug 'tpope/vim-sleuth'
" Plug 'ludovicchabant/vim-gutentags'

" Plug 'xolox/vim-misc'
" Plug 'Wraul/vim-easytags', { 'branch': 'fix-universal-detection' }
" let g:easytags_async = 1
" let g:easytags_file = '~/.vim/tags'
" let g:easytags_autorecurse = 1
" let g:easytags_resolve_links = 1

Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <leader>a gaii

" jumping with % for xml tags
runtime macros/matchit.vim

call plug#end()

""""""""""""""""""""""""""""""""""""""
" SETTINGS
""""""""""""""""""""""""""""""""""""""""

" language (let it be in the beginning)
set langmenu=none
language messages en_US.utf8

filetype plugin indent on

" FIX lag in terminal vim
set timeoutlen=1000
set ttimeoutlen=50

" backup, swap, undo
set undofile
set backup

" tabs, indent
set tabstop=2
set softtabstop=2
set shiftwidth=2
" set smarttab
" set autoindent
set cindent
set cinoptions+=(0
set expandtab
autocmd FileType * setlocal expandtab
" autocmd BufEnter * silent! lcd %:p:h

" matchparen plugin (CARE it can slow vim TOO MUCH)
" when loaded_matchparen = 1 then the plugin is disabled
let g:loaded_matchparen = 1
" let g:matchparen_timeout = 200
" let g:matchparen_insert_timeout = 200

" statusline
"set statusline=%t\ %<%m%H%W%q%=%{GetFileDirectory()}\ [%{&ff},\ %{strlen(&fenc)?&fenc:'none'}]\ %l-%L\ %p%%
set statusline=%F\ %<%m%H%W%q%=\ [%{&ff},\ %{strlen(&fenc)?&fenc:'none'}]\ %l-%L\ %p%%
set laststatus=2        " always show status bar

" highlight
set showmatch           " highlight matching [{()}]
set hlsearch
" WARN cursorline might slow vim down A LOT
set cursorline
set colorcolumn=80
autocmd BufEnter * :highlight ColorColumn ctermbg=8 ctermfg=none cterm=none
autocmd BufEnter * :highlight StatusLineNC cterm=none term=none ctermbg=none ctermfg=0

" folds
set foldcolumn=1        " Add a bit extra margin to the left

" colors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
if has('gui_running')
  try
    call SetColorScheme('gui')
  catch
    call AddUnavailMsg('Gui colorscheme')
    call SetColorScheme('tty')
  endtry

  try
    set guifont=monospace\ 12
  catch
    call AddUnavailMsg('Guifont')
    set guifont=DejaVu\ Sans\ Mono\ 12
  endtry
else
  if IsTerm256Colors()
    try
      call SetColorScheme('256')
    catch
      call AddUnavailMsg('Terminal colorscheme')
      call SetColorScheme('tty')
    endtry
  else
    call SetColorScheme('tty')
  endif
endif

" misc
" set iskeyword+=:,::,.
set encoding=utf-8
set ignorecase
set smartcase
set incsearch
set scrolloff=999
set autoread            " autoreload buffer if changes
set lazyredraw          " redraw only when we need to.
set showcmd             " show command in bottom bar
set wildmenu            " visual autocomplete for command menu
set showfulltag
set hidden
set nocompatible
set confirm
set viminfo='50,<100,s100,:1000,/1000,@1000,f1,h
set sessionoptions-=blank
set sessionoptions-=options
set shiftround          " round indentation
set backspace=indent,eol,start
set omnifunc=syntaxcomplete#Complete
setlocal shortmess+=I   " hide intro message on start
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.ropeproject/*
set wildignore+=Session.vim,*.pyc
set updatetime=2000

" gui
if has('gui_running')
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  set guioptions+=c  "no graphical popup dialogs
endif

autocmd FileType * syntax on

autocmd FileType * setlocal history=300

autocmd FileType * setlocal formatoptions-=t
autocmd FileType * setlocal formatoptions-=o
autocmd FileType * setlocal formatoptions-=r

" python
let python_highlight_all = 1
autocmd Filetype python setlocal foldmethod=indent
autocmd Filetype python setlocal foldlevel=1
autocmd Filetype python setlocal foldminlines=15
autocmd Filetype python setlocal foldnestmax=2
autocmd FileType python nmap <buffer> <leader>b Oimport pudb; pudb.set_trace()<C-[>
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal softtabstop=4
autocmd FileType python setlocal shiftwidth=4

autocmd FileType javascript nmap <buffer> <leader>b Odebugger;<C-[>

autocmd FileType lua nmap <buffer>
      \ <leader>b Oif require("os").getenv("DISPLAY") ~= ":0.0"
      \ then require("debugger")() end<C-[>
      " \ then require("mobdebug").start() end<C-[>

" restore cursor position on file open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" | endif

" delete trailing spaces
autocmd BufWrite * call DeleteTrailingWS()

""""""""""""""""""""""""""""""""""""""""
" MAPPINGS, COMMANDS
""""""""""""""""""""""""""""""""""""""""

" :W save the file as root
function! SudoSaveFile() abort
  execute (has('gui_running') ? '' : 'silent') 'write !env SUDO_EDITOR=tee sudo -e % >/dev/null'
  let &modified = v:shell_error
endfunction
cnoremap w!!! call SudoSaveFile()<CR>
cnoremap W!!! w !sudo tee % > /dev/null

" edit config files
command! Rv execute 'source ' . g:path#vimrc
command! Ev execute 'edit ' . g:path#vimrc
command! Em execute 'edit ' . "~/.tmux.conf"
command! Ems execute 'edit ' . "~/.tmuxinator/default.yml"
command! Eb execute 'edit ' . "~/.bashrc"
command! Ep execute 'edit ' . "~/.profile"
command! Ex execute 'edit ' . "~/.Xresources"
command! Et execute 'edit ' . "~/.config/alacritty/alacritty.yml"
command! Es execute 'edit ' . "~/git/linux-utils/wmctrl-session-autostart.sh"
command! Est execute 'edit ' . "~/git/linux-utils/wmctrl-session-tmux.sh"
command! Er execute 'edit ' . "~/.config/ranger/rc.conf"
command! Err execute 'edit ' . "~/.config/ranger/rifle.conf"
command! Ea execute 'edit ' . "~/.config/awesome/rc.lua"
command! Eat execute 'edit ' . "~/.config/awesome/themes/copland/theme.lua"

" fast fullscreen split/revert back
nnoremap \| <C-W>\|<C-W>_
nnoremap + <C-W>=

" open 4 splits side by side
function! SetupSplits()
  execute 'silent! e /tmp/blank'
  execute 'only'
  execute 'split'
  execute 'vsplit'
  execute 'wincmd j'
  execute 'vsplit'
  execute 'wincmd k'
endfunction
command! Ss call SetupSplits()

" save current buffer automatically
command! As autocmd CursorHold,CursorHoldI <buffer> update

" split navigation without plugin
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" disable highlighting
nnoremap <leader>h :nohl<CR>

" remove unneeded spaces
nnoremap <leader>oc :s/\([[:graph:]]\+\)[ ]\{2,\}/\1 /g<CR>

" show linenumbers
nnoremap <leader>n :set number!<CR>

" leave insert mode in terminal
tnoremap <Esc> <C-\><C-n>

" fast load session from current dir
function! LoadSession()
  let l:pwd = getcwd()
  execute 'source ' . l:pwd . '/Session.vim'
endfunction
command! Ls call LoadSession()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call SendMessages()
