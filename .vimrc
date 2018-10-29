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
set clipboard=unnamed,autoselect,unnamedplus "Clipboard vim to terminal
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

set helplang=ja,en

" ColorScheme ---------------
"colorscheme solarized
"set background=dark

" 初期状態はcursorlineを表示しない
" 以下の一行は必ずcolorschemeの設定後に追加すること
hi clear CursorLine

" 'cursorline' を必要な時にだけ有効にする
" http://d.hatena.ne.jp/thinca/20090530/1243615055
" を少し改造、number の highlight は常に有効にする
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  setlocal cursorline
  hi clear CursorLine

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      hi CursorLine term=underline cterm=underline guibg=Grey90 " ADD
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
      hi clear CursorLine " ADD
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          " setlocal nocursorline
          hi clear CursorLine " ADD
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      " setlocal cursorline
      hi CursorLine term=underline cterm=underline guibg=Grey90 " ADD
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

" Indentation ---------------
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" プロジェクトごとにlocalファイルがあればそれを読み込む
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" Display settings ---------------
set list listchars=tab:\ \ ,trail:· "タブや空白を可視化
"set nowrap                          "行折り返ししない
set wrap                          "行折り返す
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
"nmap s <Nop>
let mapleader = "s" "leaderキーを潰さずにExplorer操作へ統一

" Key Binding ---------------
" 英字配列用にノーマルモードでは;:入れ替え
nnoremap ; :
nnoremap : ;

" マクロ誤操作を防ぐため入れ替え
nnoremap Q q
nnoremap q <Nop>

" コメントアウトトグル
nmap <C-_> <Plug>(caw:i:toggle)
vmap <C-_> <Plug>(caw:i:toggle)

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

"" 次の検索結果
nnoremap <C-n> :cn<CR>
"" 前の検索結果
nnoremap <C-p> :cp<CR>

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

" go-vim
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

nmap <silent> <C-w>j <Plug>(ale_next_wrap)
nmap <silent> <C-w>k <Plug>(ale_previous_wrap)
let g:airline_section_error = '%{exists("ALEGetStatusLine") ? ALEGetStatusLine() : ""}'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

nmap + <Plug>(clurin-next)
nmap - <Plug>(clurin-prev)
vmap + <Plug>(clurin-next)
vmap - <Plug>(clurin-prev)

" ================ lightline ====================
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'], ['lint'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'lint': 'Lint',
      \ },
      \ 'component_expand': {
      \   'syntaxcheck': 'qfstatusline#Update',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! Lint()
  return exists('*ALEGetStatusLine') ? ALEGetStatusLine() : ''
endfunction

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
let g:ruby_path = system('echo $HOME/.rbenv/shims')

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
      \   [ "tigrc"  , "~/.tigrc"],
      \   [ "tmux_conf"  , "~/.tmux.conf"],
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
  noremap <silent> [unite]et :<C-u>Unite rails/spec rails/minitest<CR>
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
      \   'ruby.rails': $HOME . '/.cache/dein/repos/github.com/pocke/dicts/ruby.dict',
      \ }

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction
" ================ NeoSnippet ====================
let g:neosnippet#enable_snipmate_compatibility = 1
" remove ${x} marker when switching normal mode
let g:neosnippet#enable_auto_clear_markers = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets/, ~/.cache/dein/repos/github.com/honza/vim-snippets/snippets/'
" key-mappings.
"inoremap <Nul> <C-k>
"imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"smap <C-k>     <Plug>(neosnippet_expand_or_jump)
"xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

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

" ================ explorer設定  ====================
nmap , [explorer]
vmap , <Nop>
vmap , [explorer]

" tig-explorer
nnoremap [explorer]T :TigOpenCurrentFile<CR>
nnoremap [explorer]t :TigOpenProjectRootDir<CR>
nnoremap [explorer]g :TigGrep<space>
nnoremap [explorer]b :TigBlame<space>
""選択状態のキーワードで検索"
vnoremap [explorer]g y:TigGrep<Space><C-R>"<CR>
""カーソル上のキーワードで検索
" nnoremap [explorer]cg :<C-u>:TigGrep<Space><C-R><C-W><CR>

" ranger-explorer
nnoremap [explorer]c :<C-u>RangerOpenCurrentDir<CR>
nnoremap [explorer]f :<C-u>RangerOpenProjectRootDir<CR>

" 辞書定義
let g:ref_source_webdict_sites = {
      \   'je': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \   'ej': {
      \     'url': 'http://eow.alc.co.jp/search?q=%s',
      \   },
      \ }

" デフォルトサイト
let g:ref_source_webdict_sites.default = 'ej'

" 出力に対するフィルタ
" 最初の数行邪魔なので削除
function! g:ref_source_webdict_sites.je.filter(output)
  let l:str = substitute(a:output, '       単語帳', '', 'g')
  return join(split(str, "\n")[28 :], "\n")
endfunction

function! g:ref_source_webdict_sites.ej.filter(output)
  let l:str = substitute(a:output, '       単語帳',' ', 'g')
  return join(split(str, "\n")[28 :], "\n")
endfunction

" キーマッピング
" カーソル位置にある英単語を辞書検索
nnoremap [explorer]e :<C-u>:Ref webdict ej<Space><C-R><C-W><CR>
" 選択した英文を日本語翻訳
vnoremap [explorer]e !trans -b -sl=en -tl=ja<Space><C-R><C-W><CR>

" コマンド定義
" 英語から日本語を調べる
command! -nargs=1 E2j Ref webdict ej <args>
" 日本語から英語を調べる
command! -nargs=1 J2e Ref webdict je <args>
" 英英辞書を引く
command! -nargs=1 E2e Ref answers <args>
" 英文翻訳
command! -nargs=1 E2t trans_e2j <args>

" ================ Ctags  ====================
" ctagsを別ウィンドウで開く
nnoremap <C-k> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>

" ================ auto-save  ====================
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
"let g:auto_save_silent = 1  " do not display the auto-save notification


" ================ clurin.vim  ====================
" vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect

" http://qiita.com/syngan/items/0dd647e0f08557bbd633
" https://github.com/syngan/vim-clurin

" match order
" 1. g:clurin[&filetype]
" 2. g:clurin['-']
" 3. clurin.vim デフォルトの &filetype 用定義
" 4. clurin.vim デフォルト定義 (-)

" search order
" 1. g:clurin[&filetype]
" 2. g:clurin['-']
" 3. clurin.vim デフォルトの &filetype 用定義
" 4. clurin.vim デフォルト定義 (-)
function! g:CountUp(strs, cnt, def) abort
  " a:strs: matched text list
  " a:cnt: non zero.
  " a:def: definition
  return str2nr(a:strs[0]) + a:cnt
endfunction

" nomatch's argument is one
function! g:CtrlAX(cnt) abort
	if a:cnt >= 0
		execute 'normal!' a:cnt . "\<C-A>"
	else
		execute 'normal!' (-a:cnt) . "\<C-X>"
	endif
endfunction

function g:RubyBlockOneline(str, cnt, def) abort
  let gdefault_save = &gdefault
  let &gdefault = 0
  try
    s/\v\s*do\s*(\|.*\|)?\_s*(.*)\_s*end/{\1 \2}/Ie
  finally
    let &gdefault = gdefault_save
  endtry
endfunction

function g:RubyBlockMultiline(str, cnt, def) abort
  let save_pos = getpos('.')
  let gdefault_save = &gdefault
  let &gdefault = 0
  try
    " \1周りのスペースは=regで対応?
    s/\v\s*\{(\|.*\|)?\_s*(.*)\_s*\}$/ do \1\r\2\rend/Ie
    call feedkeys('3==')
  finally
    let &gdefault = gdefault_save
    call setpos('.', save_pos)
  endtry
endfunction

let g:clurin = {
      \ '-': {'use_default': 0, 'def': [
      \   ['true', 'false'], ['on', 'off'], ['enable', 'disable'],
      \   ['&&', '||'], ['yes', 'no'], ['Left', 'Right'], ['Up', 'Down'],
      \   [' < ', ' > '], [' <= ', ' >= '], [' == ', ' != '],
      \   ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      \   ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      \   ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      \   [{'pattern': '\v''([^'']+)''', 'replace': '''\1'''},
      \    {'pattern': '\v"([^"]+)"', 'replace': '"\1"'},],
      \ ]},
      \
      \ 'markdown': {'def': [
      \   ['[ ]', '[x]'],
      \   ['#', '##', '###', '####', '#####', ],
      \   ['-', "\t-", "\t\t-", "\t\t\t-", ],
      \   ['+', "\t+", "\t\t+", "\t\t\t+", ],
      \ ]},
      \
      \ 'vim': {'def': [
      \   ['echo ', 'echomsg '],
      \   ['nnoremap ', 'nmap '],
      \   ['inoremap ', 'imap '],
      \   ['cnoremap ', 'cmap '],
      \   ['xnoremap ', 'xmap '],
      \   ['BufWritePre', 'BufWritePost', 'BufWriteCmd'],
      \   ['BufReadPre', 'BufReadPost', 'BufReadCmd'],
      \   ['==#', '!=#' ],
      \   ['==?', '!=?' ],
      \   ['=~#', '!~#' ],
      \   ['=~?', '!~?' ],
      \   ['if', 'elseif', 'else'],
      \   [{'pattern': '\[''\(\k\+\)''\]', 'replace': '[''\1'']'},
      \    {'pattern': '\["\(\k\+\)"\]',   'replace': '["\1"]'},
      \    {'pattern': '\.\(\k\+\)',       'replace': '.\1'}],
      \ ]},
      \
      \ 'ruby ruby.rails ruby.rspec': {'def': [
      \   [{'pattern': '\v:(\k+)\s*\=\>\s*', 'replace': ':\1 => '},
      \    {'pattern': '\v(\k+)\:\s*', 'replace': '\1: '},
      \   ],
      \   [{'pattern': '\v"(\w+)"', 'replace': '"\1"'},
      \    {'pattern': '\v''(\w+)''', 'replace': '''\1'''},
      \    {'pattern': '\v:(\w+)@>(\s+\=\>)@!', 'replace': ':\1'},
      \   ],
      \   {'quit': 1, 'group': [
      \     {'pattern': '\v\s*do\s*(\|.*\|)?', 'replace': function('g:RubyBlockMultiline')},
      \     {'pattern': '\v\s*\{(\|.*\|)?\_s*.*\_s*\}$', 'replace': function('g:RubyBlockOneline')},
      \   ]},
      \   [{'pattern': '\vlambda\s*\{%(\|(.*)\|)?\s*(.*)\s*\}', 'replace': 'lambda{|\1| \2}'},
      \    {'pattern': '\v-\>\s*\((.*)\)\s*\{\s*(.*)\s*\}', 'replace': '->(\1){ \2}'},
      \    {'pattern': '\vproc\s*\{%(\|(.*)\|)?\s*(.*)\s*\}', 'replace': 'proc{|\1| \2}'},
      \   ],
      \   ['if', 'unless' ],
      \   ['while', 'until' ],
      \   ['.blank?', '.present?' ],
      \   ['include', 'extend' ],
      \   ['class', 'module' ],
      \   ['.inject', '.reject' ],
      \   ['.map', '.map!' ],
      \   ['.sub', '.sub!', '.gub', '.gub!' ],
      \   ['.clone', '.dup' ],
      \   ['.any?', '.none?' ],
      \   ['.all?', '.one?' ],
      \   ['p ', 'puts ', 'print '],
      \   ['attr_accessor', 'attr_reader', 'attr_writer' ],
      \   ['File.exist?', 'File.file?', 'File.directory?' ],
      \   ['should ', 'should_not '],
      \   ['be_truthy', 'be_falsey'],
      \   ['.to ', '.not_to '],
      \   [{'pattern': '\.to_not ', 'replace': '.to '}]
      \ ]},
      \
      \ 'zsh sh': {'def': [
      \   ['if', 'elif', 'else'],
      \   [' -a ', ' -o '],
      \   [' -z ', ' -n '],
      \   [' -eq ', ' -ne '],
      \   [' -lt ', ' -le ', ' -gt ', ' -ge '],
      \   [' -e ', ' -f ', ' -d '],
      \   [' -r ', ' -w ', ' -x '],
      \   [{'pattern': '\v\$(\w+)', 'replace': '$\1'},
      \    {'pattern': '\V"\@<!${\(\w\+\)}"\@!', 'replace': '${\1}'},
      \    {'pattern': '\V"${\(\w\+\)}"', 'replace': '"${\1}"'},],
      \ ]},
      \ 'go': {'def': [
      \   ['Print', 'Println', 'Printf'],
      \   ['Fprint', 'Fprintln', 'Fprintf'],
      \   ['Sprint', 'Sprintln', 'Sprintf'],
      \ ]},
      \}

" ================ vim-test  ====================
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" ================ その他  ====================
" Renameコマンド
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))

set laststatus=2

