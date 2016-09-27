

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


" I'm not actually sure what this does. But I think it's helpful.
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*

"filetype off                  " required
" To use vundle: 
" Install: git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" :BundleInstall to setup.
" :BundleInstall! to update.
" :BundleClean to remove old plugins. 
" set the runtime path to include Vundle and initialize
"set rtp+=~/vimfiles/bundle/Vundle.vim/
"let path='~/vimfiles/bundle'
"call vundle#begin(path)
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required


"Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/vim-scripts/ScrollColors'
"Plugin 'tpope/vim-rails'
"Plugin 'thoughtbot/vim-rspec'
Plugin 'tomasr/molokai'
Bundle "kshenoy/vim-signature"

 
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
 
" All of your Plugins must be added before the following line
" call vundle#end()            " required



"" These don't work!
" RSpec.vim mappings
" map <Leader>t :call RunCurrentSpecFile()<CR>
" map <Leader>s :call RunNearestSpec()<CR>
" map <Leader>l :call RunLastSpec()<CR>
" map <Leader>a :call RunAllSpecs()<CR>



 
 
"" Whitespace
"set tabstop=8 shiftwidth=2
"set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
"set expandtab                   " use spaces, not tabs (optional)
 

"colorscheme torte
colorscheme molokai

set fileformats+=dos


" Script for changing file comments.
" First sets marks for manipulation. 
" a = class declaration
" c = start of class comment
" d = end of class comment
" f = start of file comment (if it exists)
" g = end of file comment (if it exists)
" p = package line

function! FixPatch()
	try 
		while 1 == 1 
			/-.*\n\\ No newline at end of file.*\n+.*\nIndex
			/Index
			normal! kmi
			?@@
			normal! d'i
		endwhile 

endfunction

" Fixes the package tag. 
" Can handle both @subpackage and _ forms.
" NOT FINISHED
function! FixPackageTag()
"	normal! g'p
"	try 
"		" If there is a subpackage line.
"		s/@package \w.*\zs\_.*@subpackage \ze/\\/
"	catch
"		"If there isn't a subpackage line.
"		s/_/\\/g
"	endtry
"
"	" Move the package line to the end of the comment block. 
"	normal! dd
"	" Have to move up to catch the search.
"	normal! k
	normal! gg
	try 
		%s/\n^.*\*\s*@package.*$//g
		%s/\n^.*\*\s*@subpackage.*$//g
		"/@package
		"normal! ddgg
		"/@subpackage
		"normal! dd
	catch 

	endtry
		
	normal! g'd

	call InsertPackageLine()
endfunction

" Inserts the default package name. 
function! InsertPackageLine()
	execute "normal! O * @package "
	s/.*@/\t * @
	let @" = expand('%:p')
	normal! $p
	" Take the whole path and grab the last two folders. 
	try
		s/\w:.*\\wwwroot\\\(.*\)\\\w\+..*/\1
	catch
		s/\w:.*/\\
	endtry
	normal! mp
endfunction
			
" Fix indentation assumes b is start of blcok and e is the end. 
function! FixIndentation()
	" Fix the end of the comment if needed.
	normal! g'd
	s/\zs.*\ze\*\/
	" Fix the start of the comment block.
	normal! g'c	
	s/\s*\//\t\/
	" Fix the rest of the comment block.
	normal! j
	.,'ds/\s*\*/\t \*/g

endfunction

function! FixCopyright()
	try
		normal! gg
		/@copyright
		normal! dd
		normal! g'p
		normal! P
	catch

	endtry

	try 
		normal! gg
		/@copyright
		s/© //g
		normal! g'p
	catch
	endtry

endfunction

function! FixFirstCommentPosition()
	try
		normal! g'c
		normal! d'dG
		normal! G
		try 
			set wrapscan
			/<?
			set nowrapscan
		catch
			" If it doesn't have a <?php tag, we're done.
			return
		endtry
		normal! p
	endtry
endfunction

" Should fix a PHP file with a class. 
function! FixClassFile()
	try 
		" Go to the begining of the class and search backwards for
		" /** mark it as c for start of class comment. 
		normal! g'a
		?\/\*\*
		normal! mc
	catch
		" If it doesn't have a class comment, it needs to do the same
		" thing as no class... Just create a comment with the package
		" tag. 
		call FixNoClassFile()
		return 
	endtry 

	try 
		" Continue searching for /**
		" Mark then next one as f, file start of comment.
		normal! n
		normal! mf 

		" Go back to the class declaration and look back for the first
		" closing block */ d for end of class comment.
		normal! g'a
		?\*\/
		normal! md

		"It's assumed that if there was a second start, there is a
		"second end. Mark it g. 
		normal! n
		normal! mg

		"Then combind the two blocks.
		" Delete closing tag of first comment and move up one.
		normal! g'gddk 
		" Delete/copy the comment, including the opening tag.
		normal! dg'f
		" Go to the begining of the class comment and paste the other
		" comment. 
		normal! g'cp
		" Delete the extra opening tag.
		normal! dd

	catch
		normal! g'a
		?\*\/
		normal! md
	endtry


	call FixPackageTag()
	call FixIndentation()
	call FixCopyright()	
	call FixFirstCommentPosition()
endfunction

" Fixes a file without a class.
function! FixNoClassFile()
	
	" If there is a copywrite tag, use that comment for the file
	" comment.
	normal! gg

	try 
		execute "normal! /@copyright\<CR>"
		/\*\/
		normal! md
		?\/\*\*
		normal! mc
	catch 
		try
			/@package
			/\*\/
			normal! md
			?\/\*\*
			normal! mc
		catch
			"If there isn't a copyright or package tag, create a new tag under the
			"opening line. 
			" Have to go from bottom, becuse it won't match on the same
			" line.
			normal! G
			try 
				set wrapscan
				/?php
				set nowrapscan
			catch
				" If it doesn't have a <?php tag, we're done.
				return
			endtry
			execute "normal! o/**\<CR> */"
			normal! md
			normal! kmc
		endtry
	endtry

	call FixPackageTag()
	call FixCopyright()	
	call FixIndentation()
	call FixFirstCommentPosition()
endfunction

function! FixNewLines()
	try 
		/
		%s/(\n)/\r/g
	catch
	endtry
endfunction

function! FixEmptyComments() 
	normal! gg
	try
		%s/\s*\/\*\*\(\_s*\*\)*\/\s*\n//g
	catch
	endtry
endfunction

function! FixWhiteSpaceAfterComment()
	normal! gg
	try
		%s/\*\/\zs\_s*\ze\n\s*.\+//g
	catch
	endtry
endfunction

function! FixTagsInPackageBlock()
	normal! gg
	/@package
	/\*\/
	normal! md
	?\/\*\*
	normal! mc
	
	try 
		'c,'ds/\s*\*\s*@version.*\n//g
	catch
	endtry
	try 
		'c,'ds/\s*\*\s*@author.*\n//g
	catch
	endtry
	try 
		'c,'ds/\s*\*\s*@sub.*\n//g
	catch
	endtry
	try 
		'c,'ds/\s*\*\s*@access.*\n//g
	catch
	endtry
	try 
		'c,'ds/\s*\*\s*@copyright.*\n//g
	catch
	endtry
endfunction

function! FixRootName()
	normal! gg
	try
		%s/\*\s*@package \zs\\\ze\s*\n/root/g
	catch
	endtry
endfunction

function! FixDocument()
	if expand('%:p') =~? "\\views\\" || expand('%:p') =~? "\\vendors\\" || expand('%:p') =~? "\\build\\" || expand('%:p') =~? "\\phpmyadmin\\" || expand('%:p') =~? "\\layouts\\" || expand('%:p') =~? "\\jpgraph" || expand('%:p') =~? "\\pdf\\" || expand('%:p') =~? "\\platinum\\"
		return
	endif
	
	set nowrapscan
	delmarks!
	normal! gg


	call FixEmptyComments()
	call FixWhiteSpaceAfterComment()
	call FixTagsInPackageBlock()
	call FixRootName()
	
	update! 
	set wrapscan
endfunction

function! FindClass()
	/class.*\(\n\).*{\s*$
endfunction
