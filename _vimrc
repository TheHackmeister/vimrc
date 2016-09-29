set nocompatible		" Be iMproved, required
set encoding=utf-8

" ----- General settings -----------------------------------------------------
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

" ----- Custom shortcuts -----------------------------------------------------

" Map space to be the leader key. 
" Space doesn't appear for 'showcmd'. Can work around this by using \ as leader 
" and mapping (must be :map, not :noremap) space to \.
nmap <Space> <Leader>
nmap <Leader>n :NERDTreeToggle<CR>
" This maps S to stamp. It overwrites substitute line, which I think is dumb.
nnoremap S "_diwP 

" Resource the vimrc. Expect this to change. 
nmap <Leader>r :source $MYVIMRC<CR>


" ----- Filetype specific settings -------------------------------------------
" can add expand tab to insert spaces. 
autocmd FileType php setl shiftwidth=4 tabstop=4


" ----- Settings to investigate ----------------------------------------------

" I'm not actually sure what this does. But I think it's helpful.
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

" Can I set this based on the OS? What about it's default setting?
set fileformats+=dos


" ----- Plugins --------------------------------------------------------------
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
call plug#begin()
" Must use single quotes.
" Plug 'https://github.com/vim-scripts/ScrollColors'
Plug 'tomasr/molokai'
Plug 'kshenoy/vim-signature' 
Plug 'scrooloose/nerdtree'
" Should use Syntastic for other languages. This can use php-code-sniffer to
" double check the code, which is cool.	
Plug 'joonty/vim-phpqa'		
" Can't use without python support :(. 
" Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'jakobwesthoff/whitespacetrail' " I'm not sure this is working.
Plug 'sickill/vim-pasta' " Makes pasteing indent aware. Very nice.
call plug#end()

" ----- Plugin settings ------------------------------------------------------
colorscheme molokai		" The color scheme
autocmd vimenter * NERDTree	" Start NERDTree
autocmd vimenter * wincmd p	" Start in the opened file instead of NERDTree.


" For phpqa.
" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0
" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 0
" Show code coverage on load (default = 0)
let g:phpqa_codecoverage_autorun = 0
