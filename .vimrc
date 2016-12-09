" Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.vim/rc/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" Default plugin unread
let g:loaded_gzip              = 1
let g:loaded_zipPlugin         = 1


" ================ General Config ====================

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
"set cursorline
set clipboard=unnamed,autoselect

" Charset, Line ending -----------------
set encoding=utf-8
scriptencoding utf-8

" Cursol ---------------
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
"set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set lazyredraw

" Files ---------------
set confirm "保存されていないファイルがあるときは終了前に保存確認
set hidden "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup "ファイル保存時にバックアップファイルを作らない
set noswapfile "ファイル編集中にスワップファイルを作らない
set autoread "外部でファイルに変更がされた場合は読みなおす

"ビープの設定
"ビープ音すべてを無効にする
set visualbell t_vb=
set noerrorbells "エラーメッセージの表示時にビープを鳴らさない

"コマンドライン設定
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインの履歴を1000件保存する
set history=1000

" インサートモードから抜けると自動的にIMEをオフにする
set iminsert=0
set imsearch=-1
""Ctrl-Cでインサートモードを抜ける
inoremap <C-c> <ESC>

" ノーマルモード時だけ ; と : を入れ替える
nnoremap ; :
nnoremap : ;

".vimrcの編集用
nnoremap <Space>. :<C-u>tabedit $HOME/dotfiles/.vimrc<CR>

".vimプラグイン管理ファイルの編集用
nnoremap <Space>, :<C-u>tabedit $HOME/dotfiles/.vim/rc/dein.toml<CR>

" 行移動を改行コードを意識した移動へ
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" 自動コメントフォーマットをオフ
set formatoptions-=ro

" Markdownプレビュー
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a chrome'

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden
syntax enable
set background=dark
colorscheme solarized

"turn on syntax highlighting
syntax on

let mapleader=","

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

"set foldmethod=indent   "fold based on indent

set foldenable
set foldmethod=syntax

autocmd InsertEnter * if !exists('w:last_fdm')
            \| let w:last_fdm=&foldmethod
            \| setlocal foldmethod=manual
            \| endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm')
            \| let &l:foldmethod=w:last_fdm
            \| unlet w:last_fdm
            \| endif
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
set gdefault

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"インサートモードで bash 風キーマップ
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D<Right>
inoremap <C-u> <C-o>d^
inoremap <C-w> <C-o>db

" 波線で表示する場合は、以下の設定を行う
" エラーを赤字の波線で
"execute "highlight qf_error_ucurl gui=undercurl guisp=Red"
"let g:hier_highlight_group_qf  = "qf_error_ucurl"
"" 警告を青字の波線で
"execute "highlight qf_warning_ucurl gui=undercurl guisp=Blue"
"let g:hier_highlight_group_qfw = "qf_warning_ucurl"

augroup add_syntax_hilight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead *.json.jbuilder            set ft=ruby
  autocmd BufNewFile,BufRead *.erb                      set ft=eruby
  autocmd BufNewFile,BufRead *.scss                     set ft=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set ft=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set ft=markdown
augroup END

" Other
set rtp+=~/.fzf

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END


"" {{{lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntaxcheck': 'qfstatusline#Update',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != expand('%:p') ? expand('%:p') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
set laststatus=2
set t_Co=256
"}}}


vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"quickrun

augroup ansiesc
  autocmd!
  autocmd FileType quickrun AnsiEsc
augroup END

" シンタックスチェックは<Leader>+wで行う
nnoremap <Leader>w :<C-u>WatchdogsRun<CR>

" let g:watchdogs_check_BufWritePost_enables = {
"       \   'sh':         1,
"       \   'sass':       1,
"       \   'scss':       1
"       \}
"       " \   "javascript": 1,
"       " \   "ruby": 1,

let g:watchdogs_check_CursorHold_enable = 0
let g:watchdogs_check_BufWritePost_enable = 0

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"watchdogs_checker
let g:quickrun_config = {
      \   '_' : {
      \       'hook/close_quickfix/enable_exit' : 1,
      \       'hook/close_buffer/enable_failure' : 1,
      \       'hook/close_buffer/enable_empty_data' : 1,
      \       'outputter' : 'multi:buffer:quickfix',
      \       'outputter/buffer/split' : ':botright 8sp',
      \       'runner' : 'vimproc',
      \       'runner/vimproc/updatetime' : 40,
      \   },
      \   'watchdogs_checker/_' : {
      \       'outputter/quickfix/open_cmd' : '',
      \       'hook/qfsigns_update/enable_exit' : 1,
      \       'hook/back_window/enable_exit' : 1,
      \       'hook/back_window/priority_exit' : 100,
      \   },
      \}
let g:quickrun_config['ruby/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       'cmdopt' : '-S -a -D'
      \   }
let g:quickrun_config['ruby.rails/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       'cmdopt' : '-R -S -a -D'
      \   }
let g:quickrun_config['ruby.rspec/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/rubocop',
      \       'cmdopt' : '-R -S -a -D'
      \   }
let g:quickrun_config['coffee/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/coffeelint',
      \   }
let g:quickrun_config['jade/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/jade'
      \   }
let g:quickrun_config['css/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/csslint'
      \   }
let g:quickrun_config['javascript/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['javascript.jsx/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/eslint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['markdown/watchdogs_checker'] = {
      \       'command': 'textlint',
      \       'type': 'watchdogs_checker/textlint',
      \       'cmdopt' : '--fix'
      \  }
let g:quickrun_config['sh/watchdogs_checker'] = {
      \       'command' : 'shellcheck', 'cmdopt' : '-f gcc',
      \       'type': 'watchdogs_checker/shellcheck'
      \  }
let g:quickrun_config['vim/watchdogs_checker'] = {
      \     'type': executable('vint') ? 'watchdogs_checker/vint' : '',
      \     'command'   : 'vint',
      \     'exec'      : '%c %o %s:p' ,
      \   }
let g:quickrun_config['json/watchdogs_checker'] = {
      \       'type': 'watchdogs_checker/jsonlint',
      \       'cmdopt' : '-i'
      \  }

" execute
let g:quickrun_config['html'] = { 'command' : 'open', 'exec' : '%c %s', 'outputter': 'browser' }

" " If syntax error, cursor is moved at line setting sign.
"let g:qfsigns#AutoJump = 1

" If syntax error, view split and cursor is moved at line setting sign.
"let g:qfsigns#AutoJump = 2

let g:Qfstatusline#UpdateCmd = function('lightline#update')
" watchdogs.vim の設定を追加
call watchdogs#setup(g:quickrun_config)

let g:unite_force_overwrite_statusline    = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"" {{{Unite
" " インサートモードで開始
let g:unite_enable_start_insert=1
" 最近のファイルの個数制限
let g:unite_source_file_mru_limit           = 1000
let g:unite_source_file_mru_filename_format = ''
" file_recのキャッシュ
let g:unite_source_rec_max_cache_files = 50000
" let g:unite_source_rec_min_cache_files = 100


let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.git = {
    \ 'description' : '            gestionar repositorios git
        \                            ⌘ [espacio]g',
    \}
augroup unite_global_keymap
  autocmd!
  autocmd BufEnter * :call s:unite_keymap()
augroup END
"prefix keyの設定
function! s:unite_keymap()
  nnoremap [unite] <Nop>
  vmap <Space> <Nop>
  vmap <Space> [unite]
  nmap <Space> [unite]

  nnoremap <silent> [unite]i :<C-u>Unite<Space>
  "スペースキーとaキーでカレントディレクトリを表示
  nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  "スペースキーとmキーでプロジェクト内で最近開いたファイル一覧を表示
  nnoremap <silent> [unite]m :<C-u>UniteWithProjectDir<Space>file_mru<CR>
  "スペースキーとMキーで最近開いたファイル一覧を表示
  nnoremap <silent> [unite]M :<C-u>Unite<Space>file_mru<CR>
  "スペースキーとdキーで最近開いたディレクトリを表示
  nnoremap <silent> [unite]d :<C-u>Unite<Space> directory_mru<CR>
  "スペースキーとbキーでバッファを表示
  nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
  "スペースキーとpキーでプロジェクト内を表示
  nnoremap <silent> [unite]p :<C-u>Unite file_rec/async:!<CR>

  augroup unite_jump
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype)
          \|      nnoremap <buffer> [unite]t :<C-u>Unite jump<CR>
          \|  endif
  augroup END

  ""スペースキーとyキーでヒストリ/ヤンクを表示
  nnoremap <silent> [unite]y :<C-u>Unite<Space> -buffer-name=register register<CR>
  "スペースキーとoキーでoutline
  nnoremap <silent> [unite]o :<C-u>Unite<Space> outline -prompt-direction="top"<CR>
  "unite-quickfixを呼び出し
  " multi-line を切る
  let g:unite_quickfix_is_multiline=0
  call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
  call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')
  nnoremap <silent> [unite]q :<C-u>Unite<Space> -no-quit -wrap quickfix<CR>
  ""スペースキーとgキーでgrep
  " vnoremap <silent> [unite]/g :Unite grep::-iHRn:<C-R>=escape(@", '\\.*$^[]')<CR><CR>
  " grep検索
  nnoremap <silent> [unite]G  :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> [unite]cG :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR> <C-R><C-W>
  " git-grep
  nnoremap <silent> [unite]g  :<C-u>Unite grep/git:. -buffer-name=search-buffer <CR>
  nnoremap <silent> [unite]cg :<C-u>Unite grep/git:. -buffer-name=search-buffer <CR> <C-r><C-W>

  " grep検索結果の再呼出
  nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
  " " bookmark
  nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>

  nnoremap <silent> [unite]<CR> :<C-u>Unite file_rec/git -buffer-name=search-buffer <CR>

  ""unite-rails
  noremap <silent> [unite]ec :<C-u>Unite rails/controller<CR>
  noremap <silent> [unite]em :<C-u>Unite rails/model<CR>
  noremap <silent> [unite]ev :<C-u>Unite rails/view<CR>
  noremap <silent> [unite]eh :<C-u>Unite rails/helper<CR>
  noremap <silent> [unite]es :<C-u>Unite rails/stylesheet<CR>
  noremap <silent> [unite]ej :<C-u>Unite rails/javascript<CR>
  noremap <silent> [unite]er :<C-u>Unite rails/route<CR>
  noremap <silent> [unite]eg :<C-u>Unite rails/gemfile<CR>
  noremap <silent> [unite]et :<C-u>Unite rails/spec<CR>
  noremap <silent> [unite]el :<C-u>Unite rails/log<CR>
  noremap <silent> [unite]ed :<C-u>Unite rails/db<CR>

  "unite-giti
  noremap <silent> [unite]ti :<C-u>Unite giti<CR>
  noremap <silent> [unite]ts :<C-u>Unite giti/status<CR>

endfunction
"unite.vimを開いている間のキーマッピング
augroup unite_local_keymap
  autocmd!
  autocmd FileType unite* call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  " rerwite chache
  nnoremap <C-c> <Plug>(unite_redraw)
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <ESC><ESC> <Plug>(unite_exit)
  " normal modeでも基本の挙動は一致させる
  nmap <buffer> <C-n> j
  nmap <buffer> <C-p> k
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "ctrl+kでauto-previewモードにする
  nmap <buffer> <C-k> <Plug>(unite_toggle_auto_preview)
  imap <buffer> <C-k> <Plug>(unite_toggle_auto_preview)
  "ctrl+sで縦に分割して開く
  nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  "ctrl+vでに分割して開く
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  "ctrl+oでその場所に開く
  nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')

endfunction
"}}}

" neocomplete {{{
let g:neocomplete#enable_at_startup               = 1
"let g:neocomplete#auto_completion_start_length    = 2
let g:neocomplete#enable_ignore_case              = 1
" let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_cursor_hold_i            = 1
" let g:neocomplete#enable_camel_case               = 1
" let g:neocomplete#enable_fuzzy_completion         = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'

" rsense
let g:neocomplete#force_omni_input_patterns      = {}
let g:neocomplete#force_omni_input_patterns = {
      \   'ruby' : '[^. *\t]\.\|\h\w*::',
      \   'rails' : '[^. *\t]\.\|\h\w*::',
      \   'rspec' : '[^. *\t]\.\|\h\w*::',
      \   'eruby' : '[^. *\t]\.\|\h\w*::',
      \   'ruby.rails' : '[^. *\t]\.\|\h\w*::',
      \   'ruby.rspec' : '[^. *\t]\.\|\h\w*::',
      \   'eruby.html' : '[^. *\t]\.\|\h\w*::'
      \}

let g:rsenseUseOmniFunc = 1

let g:neocomplete#sources#dictionary#dictionaries = {
      \   'ruby': $HOME . '/.cache/dein/repos/github.com/pocke/dicts/ruby.dict',
      \ }

" "NeoSnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets/, ~/.cache/dein/repos/github.com/honza/vim-snippets/snippets/'

" "NeoSnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 1
" Plugin key-mappings.
imap <Nul> <C-Space>
imap <C-Space>     <Plug>(neosnippet_expand_or_jump)
smap <C-Space>     <Plug>(neosnippet_expand_or_jump)
xmap <C-Space>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" rails
"   autocmd!
"   autocmd BufEnter * if exists("b:rails_root") | NeoCompleteSetFileType ruby.rails | endif
"   autocmd BufEnter * if (expand("%") =~ "_spec\.rb$") || (expand("%") =~ "^spec.*\.rb$") | NeoCompleteSetFileType ruby.rspec | endif
" augroup END
let g:neosnippet#snippets_directory = $HOME . '/.vim/snippets'

" enable ruby & rails snippet only rails file
function! s:RailsSnippet()
  if exists('b:rails_root') && (&filetype == 'ruby')
    set ft=ruby.rails
  endif
endfunction

function! s:RSpecSnippet()
  if (expand('%') =~ "_spec\.rb$") || (expand('%') =~ "^spec.*\.rb$")
    set ft=ruby.rspec
  endif
endfunction

augroup rails_snippet
  autocmd!
  au BufEnter * call s:RailsSnippet()
  au BufEnter * call s:RSpecSnippet()
augroup END

" open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

set cmdheight=2

" ranger
function! RangeChooser()
  let temp = tempname()
  " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
  " with ranger 1.4.2 through 1.5.0 instead.
  "exec 'silent !ranger --choosefile=' . shellescape(temp)
  if has("gui_running")
    exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
  else
    exec 'silent !ranger --choosefiles=' . shellescape(temp)
  endif
  if !filereadable(temp)
    redraw!
    " Nothing to read.
    return
  endif
  let names = readfile(temp)
  if empty(names)
    redraw!
    " Nothing to open.
    return
  endif
  " Edit the first item.
  exec 'edit ' . fnameescape(names[0])
  " Add any remaning items to the arg list/buffer list.
  for name in names[1:]
    exec 'argadd ' . fnameescape(name)
  endfor
  redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>


"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

autocmd BufWritePre * :%s/\s\+$//ge

nnoremap <C-k> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
