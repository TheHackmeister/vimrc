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
set iskeyword+=^_		" Makes _ similar to - for word detection. Could also use autocmd to do it selectively.

" This allows me to reference files in these folders in an OS agnostic way. 
if has('win32') || has ('win64')
	let $VIMHOME = $HOME."/vimfiles"
else
	let $VIMHOME = $HOME."/.vim"
endif

" ----- Custom shortcuts -----------------------------------------------------

" Map space to be the leader key.
" Space doesn't appear for 'showcmd'. Can work around this by using \ as leader
" and mapping (must be :map, not :noremap) space to \.
nmap <Space> <Leader>
nmap <Leader>n :NERDTreeToggle<CR>
" This maps S to stamp. It overwrites substitute line, which I think is dumb
" anyway.
nnoremap S "_diwP

" Consider remapping : to ;

" If W gets changed to w in places it's not supposed to, check out
" http://stackoverflow.com/questions/3878692/aliasing-a-command-in-vim/3879737#3879737
" Seems to be OK though.
command! W w 			" lets :W write.

" Resource the vimrc. Expect this to change.
nmap <Leader>r :source $MYVIMRC<CR>

" Shortcuts for cheat-sheet. 
" eh - Edit Help. 
nmap <Leader>h :h myhelp<CR>
nmap <Leader>eh :vs $VIMHOME/plugged/vim-myhelp/doc/myhelp.txt<CR>
autocmd FileType help noremap <buffer> q :q<cr>

" Change working directory to be the current files location. 
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" ----- Filetype specific settings -------------------------------------------
" can add expand tab to insert spaces.
autocmd FileType php setl shiftwidth=4 tabstop=4
autocmd FileType py setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab
" Remap q to quit in help buffers. Would also consider space. 



" ----- OS Specific settings ------------------------------------------------
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_win32")
        set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powe:h10
    endif
endif

" ----- Settings to investigate ----------------------------------------------

" I'm not actually sure what this does. But I think it's helpful.
"set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

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
Plug 'tomasr/molokai'			" Color scheme.
Plug 'chriskempson/vim-tomorrow-theme'	" Color scheme.
Plug 'kshenoy/vim-signature' 		" Puts marks next to line numbers.
Plug 'scrooloose/nerdtree'		" File navigation.
Plug 'Xuyuanp/nerdtree-git-plugin'	" For git integration.
Plug 'joonty/vim-phpqa'			" Better php highlighting and linting.
Plug 'scrooloose/syntastic'		" Better highlighting and linting.
" Can't use without python support :(.
" Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'jakobwesthoff/whitespacetrail' 	" I'm not sure this is working.
Plug 'sickill/vim-pasta'		" Makes pasteing indent aware. Very nice.
" To install powerline/airline fonts see: https://github.com/powerline/fonts
Plug 'vim-airline/vim-airline'		" Better bottom bar.
Plug 'vim-airline/vim-airline-themes'	" Theme for bottom bar.
Plug 'mhinz/vim-signify'		" Src Ctl markups next to line numbers
"Plug 'airblade/vim-gitgutter'		" Git markups next to line numbers.
Plug 'theHackmeister/vim-myhelp'	" In vim cheatsheet. 
call plug#end()

" ----- Plugin settings ------------------------------------------------------
colorscheme tomorrow-night	" The color scheme
let g:airline_theme='tomorrow'	" I've also liked molokai
" This changes the SignColumn background to the match the rest of the text.
highlight SignifySignAdd ctermbg=none
highlight SignifySignDelet ctermbg=none
highlight SignifySignChange ctermbg=none

autocmd vimenter * NERDTree	" Start NERDTree
autocmd vimenter * wincmd p	" Start in the opened file instead of NERDTree.


" For phpqa.
" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0
" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 0
" Show code coverage on load (default = 0)
let g:phpqa_codecoverage_autorun = 0

" For syntastic.
" Might consider using just syntastic and removing phpqa?
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['php'] }


" For vim-pasta
" It doesn't work as well in python, but it still can take an educated guess.
let g:pasta_enabled_filetypes = ['python']

" For airline
" Problems:
" 	Missing some chars.
"	Whitespace detection I want off.
"	Bigger buff numbers on buff bar.
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" Turn off whitespace detection.
" Can look for bar customization with :h airline-customization
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab


" For actual symbols. 
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "*",
    \ "Staged"    : "+",
    \ "Untracked" : "U",
    \ "Renamed"   : ">",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "X",
    \ "Dirty"     : "x",
    \ "Clean"     : " ",
    \ "Unknown"   : "?"
    \ }

"let g:gitgutter_diff_base = '19d409'
"let g:gitgutter_async=0
"let g:gitgutter_log=1
