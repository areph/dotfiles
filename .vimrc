" dein settings'
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

" デフォルトプラグインを読み込まない
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

" ================ General Config ====================
set number                       "Line numbers are good
set backspace=indent,eol,start   "Allow backspace in insert mode
set history=1000                 "Store lots of :cmdline history
set showcmd                      "Show incomplete cmds down the bottom
set showmode                     "Show current mode down the bottom
set gcr=a:blinkon0               "Disable cursor blink
set visualbell                   "No sounds
set autoread                     "Reload files changed outside vim
"set cursorline                   "Display current cursol line
set clipboard=unnamed,autoselect "Clipboard vim to terminal
set formatoptions-=ro            "Comment line format off

" Charset, Line ending -----------------
set encoding=utf-8
scriptencoding utf-8

" Cursol ---------------
set backspace=indent,eol,start   "Backspaceキーの影響範囲に制限を設けない
"set whichwrap=b,s,h,l,<,>,[,]   "行頭行末の左右移動で行をまたぐ
set lazyredraw                   "マクロなどの描写を行わない

" Files ---------------
set confirm                      "保存されていないファイルがあるときは終了前に保存確認
set hidden                       "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set nobackup                     "ファイル保存時にバックアップファイルを作らない
set noswapfile                   "ファイル編集中にスワップファイルを作らない
set autoread                     "外部でファイルに変更がされた場合は読みなおす
set nowb                         "バックアップを保持しない

" Beep ---------------
set visualbell t_vb=             "ビープ音すべてを無効にする
set noerrorbells                 "エラーメッセージの表示時にビープを鳴らさない

" Command line ---------------
set wildmenu wildmode=list:longest,full "コマンドラインモードでTABキーによるファイル名補完を有効にする
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
" 保存時に最後尾の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

" ColorScheme ---------------
colorscheme solarized
set background=dark

" Indentation ---------------
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Display settings ---------------
set list listchars=tab:\ \ ,trail:· "タブや空白を可視化
set nowrap                          "行折り返ししない
" インデントタブを可視化
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
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

" Scrolling ---------------
set scrolloff=8                     "縦スクロールした際の視界確保行数
set sidescrolloff=16                "横スクロールした際の視界確保行数
set sidescroll=1                    "横スクロール数は1ずつ

" Search settings ---------------
set incsearch                       "検索ワードをインクリメンタルサーチ
set hlsearch                        "検索ワードをハイライト
set ignorecase                      "大文字小文字を区別しない
set smartcase                       "大文字で検索した場合はignorecaseにしない
set gdefault                        "置換の際にg指定しなくても繰り返し置換する

" コマンド表示行を2行へ拡張
set cmdheight=2

" Leader setting ---------------
let mapleader=","

" Key Binding ---------------
" 英字配列用にノーマルモードでは;:入れ替え
nnoremap ; :
nnoremap : ;

" マクロ誤操作を防ぐため入れ替え
nnoremap Q q
nnoremap q <Nop>

" コメントアウトトグル
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)

" ペースト時にインデントさせない
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

inoremap <C-c> <ESC>             "Ctrl-Cでインサートモードを抜ける

" filytype各種ON
filetype plugin on
filetype indent on

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" インサートモードで bash 風キーマップ
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

" vを押下するごとに選択範囲を拡張
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ウィンドウサイズ変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" Syntax highlight ---------------
syntax enable                    "シンタクスハイライトを有効化
augroup add_syntax_hilight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead *.json.jbuilder            set ft=ruby
  autocmd BufNewFile,BufRead *.erb                      set ft=eruby
  autocmd BufNewFile,BufRead *.scss                     set ft=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set ft=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set ft=markdown
augroup END


" ================ lightline ====================
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


" ================ Quickrun & Watchdogs ====================
augroup ansiesc
  autocmd!
  autocmd FileType quickrun AnsiEsc
augroup END

" シンタックスチェックは<Leader>+wで行う
nnoremap <Leader>w :<C-u>WatchdogsRun<CR>

let g:watchdogs_check_CursorHold_enable = 0
let g:watchdogs_check_BufWritePost_enable = 0

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

" watchdogs_checker
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

let g:Qfstatusline#UpdateCmd = function('lightline#update')
" watchdogs.vim の設定を追加
call watchdogs#setup(g:quickrun_config)

let g:unite_force_overwrite_statusline    = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" ================ Unite ====================
" インサートモードで開始
let g:unite_enable_start_insert=1
" 最近のファイルの個数制限
let g:unite_source_file_mru_limit           = 1000
let g:unite_source_file_mru_filename_format = ''
" file_recのキャッシュ
let g:unite_source_rec_max_cache_files = 50000

augroup unite_global_keymap
  autocmd!
  autocmd BufEnter * :call s:unite_keymap()
augroup END

" unite-menu shortcut {{{
if !exists("g:unite_source_menu_menus")
    let g:unite_source_menu_menus = {}
endif

let g:unite_source_menu_menus.shortcut = {
      \   "description" : "shortcut"
      \}

let g:unite_source_menu_menus.shortcut.candidates = [
      \   [ "zshrc"  , "~/.zshrc"],
      \   [ "vimrc"  , "~/.vimrc"],
      \   [ "dein.toml"  , "~/dotfiles/.vim/rc/dein.toml"],
      \   [ "Github", "OpenBrowser https://github.com/" ],
      \   [ "Gist", "OpenBrowser https://gist.github.com/" ],
      \   [ "Blog Edit", "OpenBrowser http://40balmung.hatenablog.com/#edit" ],
      \]

function! g:unite_source_menu_menus.shortcut.map(key, value)
  let [word, value] = a:value

  if isdirectory(value)
    return {
          \               "word" : "[directory] ".word,
          \               "kind" : "directory",
          \               "action__directory" : value
          \           }
  elseif !empty(glob(value))
    return {
          \               "word" : "[file] ".word,
          \               "kind" : "file",
          \               "default_action" : "tabdrop",
          \               "action__path" : value,
          \           }
  else
    return {
          \               "word" : "[command] ".word,
          \               "kind" : "command",
          \               "action__command" : value
          \           }
  endif
endfunction

" Uniteトリガーをスペースキーに設定
function! s:unite_keymap()
  nnoremap [unite] <Nop>
  vmap <Space> <Nop>
  vmap <Space> [unite]
  nmap <Space> [unite]

  " プロジェクトのディレクトリ取得
  function! GetProjectDir() abort " {{{
    let l:buffer_dir = expand('%:p:h')
    let l:project_dir = vital#of('vital').import('Prelude').path2project_directory(l:buffer_dir, 1)
    if empty(l:project_dir) && exists('g:project_dir_pattern')
      let l:project_dir = matchstr(l:buffer_dir, g:project_dir_pattern)
    endif

    if empty(l:project_dir)
      return l:buffer_dir
    else
      return l:project_dir
    endif
  endfunction " }}}

  augroup unite_jump
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype)
          \|      nnoremap <buffer> [unite]t :<C-u>Unite jump<CR>
          \|  endif
  augroup END

  nnoremap <silent> [unite]i :<C-u>Unite<Space>
  "aキーでカレントディレクトリを表示
  nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  "mキーでプロジェクト内で最近開いたファイル一覧を表示
  nnoremap <silent> [unite]m :<C-u>UniteWithProjectDir<Space>file_mru<CR>
  "Mキーで最近開いたファイル一覧を表示
  nnoremap <silent> [unite]M :<C-u>Unite<Space>file_mru<CR>
  "dキーで最近開いたディレクトリを表示
  nnoremap <silent> [unite]d :<C-u>Unite<Space> directory_mru<CR>
  "bキーでバッファを表示
  nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
  "pキーでプロジェクト内を表示
  nnoremap [unite]p :<C-u>call <SID>unite_file_project()<CR>
  function! s:unite_file_project()
    let l:opts = (a:0 ? join(a:000, ' ') : '')
    let l:project_dir = GetProjectDir()

    if isdirectory(l:project_dir.'/.git')
      execute 'lcd '.l:project_dir
      execute 'Unite '.opts.' file_rec/git:--cached:--others:--exclude-standard'
    else
      execute 'Unite '.opts.' file_rec/async:'.l:project_dir
    endif
  endfunction

  "yキーでヒストリ/ヤンクを表示
  nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
  "oキーでoutline
  nnoremap <silent> [unite]o :<C-u>Unite<Space> outline -prompt-direction="top"<CR>
  "unite-quickfixを呼び出し
  " multi-line を切る
  let g:unite_quickfix_is_multiline=0
  call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
  call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')
  nnoremap <silent> [unite]q :<C-u>Unite<Space> -no-quit -wrap quickfix<CR>
  " grep検索
  nnoremap <silent> [unite]G  :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR>
  " カーソル位置の単語をgrep検索
  nnoremap <silent> [unite]cG :<C-u>UniteWithProjectDir grep:. -buffer-name=search-buffer <CR> <C-R><C-W>
  " git-grep検索
  nnoremap <silent> [unite]g  :<C-u>Unite grep/git:/:--untracked -buffer-name=search-buffer<CR>
  " カーソル位置の単語をgit-grep検索
  nnoremap <silent> [unite]cg :<C-u>Unite grep/git:/:--untracked -buffer-name=search-buffer<CR><C-R><C-W>

  " grep検索結果の再呼出
  nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer <CR>
  " bookmark
  nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>

  nnoremap <silent> [unite]<CR> :<C-u>Unite file_rec/git -buffer-name=search-buffer <CR>

  " Unite menu shortcut
  nnoremap <silent> [unite]ll :Unite menu:shortcut<CR>

  " unite-rails
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

  " unite-giti
  noremap <silent> [unite]ti :<C-u>Unite giti<CR>
  noremap <silent> [unite]ts :<C-u>Unite giti/status<CR>

  " unite grep に ag(The Silver Searcher) を使う
  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
  endif
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
  "ctrl+vでに分割して開く
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('right')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('right')
endfunction

" ================ Neocomplete ====================
let g:neocomplete#enable_at_startup               = 1
let g:neocomplete#enable_ignore_case              = 1
let g:neocomplete#enable_cursor_hold_i            = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'

let g:neocomplete#sources#dictionary#dictionaries = {
      \   'ruby': $HOME . '/.cache/dein/repos/github.com/pocke/dicts/ruby.dict',
      \ }

" ================ NeoSnippet ====================
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets/, ~/.cache/dein/repos/github.com/honza/vim-snippets/snippets/'
" key-mappings.
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

" ================ Open browser ====================
let g:netrw_nogx = 1 " disable netrw's gx mapping.
" カーソル位置にある単語をGoogle検索
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" ================ Ranger ====================
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

" ================ Ctags  ====================
" ctagsを別ウィンドウで開く
nnoremap <C-k> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>

