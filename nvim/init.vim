"dein Scripts-----------------------------{{{

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.cache/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/nvim/dein')
  let g:dein#cache_directory = $HOME . '/.cache/nvim/dein'
  call dein#begin('$HOME/.cache/nvim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/nvim/dein/repos/github.com/Shougo/dein.vim')

  let s:toml_dir  = $HOME . '/.config/nvim'
  let s:toml      = s:toml_dir . '/nvim_dein.toml'
  let s:lazy_toml = s:toml_dir . '/nvim_dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------}}}


" Key Binding-----------------------------{{{

" 英字配列用にノーマルモードでは;:入れ替え
nnoremap ; :
nnoremap : ;

" マクロ誤操作を防ぐため入れ替え
nnoremap Q q
nnoremap q <Nop>

" コメントアウトトグル ※動いてないので要調査
nmap <C-_> <Plug>(caw:zeropos:toggle)
vmap <C-_> <Plug>(caw:zeropos:toggle)

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

" 折り返し行移動
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

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


" ================ fzf設定  ====================
" Default fzf layout
" - down / up / left / right
" let g:fzf_layout = { 'down': '~40%' }

" like Spacemacs
let mapleader = "\<Space>"

" vimのバッファを検索
nnoremap <Leader>b :Buffers<CR>
" GitFilesを検索
nnoremap <Leader>f :GFiles<CR>
" Ag grep
nnoremap <Leader>g :Ag!<CR>
" カレントディレクトリ配下を検索
nnoremap <Leader>a :call fzf#vim#files(expand("%:p:h"), fzf#vim#with_preview())<CR>

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)

" Mapping selecting mappings
" vimのマッピングを検索して実行できる
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" End Key Binding-----------------------------}}}


" General Settings-----------------------------{{{{{{

set ambiwidth=double                        " 2バイト文字でカーソル位置がずれる問題の対策
set iminsert=0 imsearch=0                   " 挿入モード・検索モードでのデフォルトのIME状態設定
set expandtab                               " タブ入力時に自動的にスペースに変える
set tabstop=2                               " 1タブの幅
set softtabstop=2                           " 1タブ当たりの半角スペースの個数 (通常入力時)
set shiftwidth=2                            " 1タブ当たりの半角スペースの個数 (コマンドや自動インデント)
set clipboard+=unnamedplus                  " nvimのバッファをClipboardと共有
set showmatch matchtime=1                   " 入力時対応する括弧に飛ぶ。表示時間 ＝ 0.1 * matchtime (秒)
set autoindent                              " 自動的にインデントする (noautoindent:インデントしない)
set backspace=indent,eol,start              " バックスペースでインデントや改行を削除できるようにする
set showmatch matchtime=1                   " 入力時対応する括弧に飛ぶ。表示時間 ＝ 0.1 * matchtime (秒)
set nobackup                                " バックアップファイルを作成しない
inoremap , ,<Space>                         " , の後に自動的にスペースを入れる
set virtualedit=block                       " 文字が無い部分でも矩形選択を可能にする
set number                                  " 行番号を表示
set ignorecase                              " 検索時に大文字小文字を無視 (noignorecase:無視しない)
set smartcase                               " 大文字小文字の両方が含まれている場合は大文字小文字を区別
set wrapscan                                " 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set inccommand=split                        " `%s/hoge/fuga/g`など置換する際にウィンドゥを開いてわかりやすく表示
nnoremap <ESC><ESC> :nohlsearch<CR>         " Esc 2回でハイライトを消す
au FileType vim setlocal foldmethod=marker  " vimの折りたたみにマーカーを付ける
set confirm                                 " 保存されていないファイルがあるときは終了前に保存確認
set hidden                                  " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set noswapfile                              " ファイル編集中にスワップファイルを作らない

" End General Settings-----------------------------}}}}}}


" ale(エラーチェック)-----------------------------

" nmap <silent> <C-w>j <Plug>(ale_next_wrap)
" nmap <silent> <C-w>k <Plug>(ale_previous_wrap)
" let g:airline_section_error = '%{exists("ALEGetStatusLine") ? ALEGetStatusLine() : ""}'
" let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

let g:ale_linters = {'javascript': ['eslint', 'flow']}
let g:ale_fixers = {
      \'ruby':       ['rubocop'],
      \'json':       ['fixjson'],
      \'javascript': ['eslint']
      \}

" End ale(エラーチェック)-----------------------------


" Other Utilty-----------------------------

" 保存時に最後尾の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

" End Other Utilty-----------------------------

