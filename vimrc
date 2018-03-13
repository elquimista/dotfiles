set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'

call vundle#end()
filetype plugin indent on

source $VIMRUNTIME/vimrc_example.vim
syntax on
set background=dark
colorscheme solarized
set mouse=
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set backupdir=~/.vimtemp
set number
set noundofile
