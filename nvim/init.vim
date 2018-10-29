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

" Required:
filetype plugin indent on
syntax enable
"End dein Scripts-------------------------}}}


" Key Binding-----------------------------{{{
" 英字配列用にノーマルモードでは;:入れ替え
nnoremap ; :
nnoremap : ;
" End Key Binding-----------------------------}}}


" General Settings-----------------------------{{{{{{
au FileType vim setlocal foldmethod=marker "vimの折りたたみにマーカーを付ける
set clipboard+=unnamedplus "Clipboard vim to terminal
" End General Settings-----------------------------}}}}}}
