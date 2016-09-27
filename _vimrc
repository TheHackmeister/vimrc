set nocompatible		" Be iMproved, required
set encoding=utf-8

" General settings.
set showcmd			" Display incomplete commands
set number			" Display line numbers
set noswapfile			" Don't keep the swap files
set ruler			" Display curser position on bottom of window
set laststatus=2		" Always display the status line 
set nowrap                      " Don't wrap lines
set backspace=indent,eol,start  " Backspace through everything in insert mode
syntax enable			" Turn on syntax highlighting
filetype plugin indent on 	" Allows intelligent auto-indenting. 
set splitright			" Split verticly instead of horizontally
set smartindent
set autoindent
set hlsearch                    " Highlight matches
set incsearch                   " Incremental searching
set ignorecase                  " Searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
colorscheme molokai'		" The color scheme

" Settings to investigate.

" I'm not actually sure what this does. But I think it's helpful.
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

" Can I set this based on the OS? What about it's default setting?
set fileformats+=dos

"" Whitespace
"set tabstop=8 shiftwidth=2
"set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
"set expandtab                   " use spaces, not tabs (optional)


" Begin loading plugins. 
" 
" Install plug on linux via: 
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Install plug with powershell via:
" md ~\vimfiles\autoload
" $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" (New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\vimfiles\autoload\plug.vim"))
"
" :PlugInstall to install Plugins.
" :PlugUpdate to upgrade Plugins.
" :PlugUpgrade to upgrade Plug.
" :PlugClean will removed unused directories. 
" 
" For more: https://github.com/junegunn/vim-plug
call plug#begin() " Might need path as argument.
" Plug 'https://github.com/vim-scripts/ScrollColors'
Plug 'tomasr/molokai'
Plug 'kshenoy/vim-signature' " Plug complains about needing an argument. 
call plug#end()

