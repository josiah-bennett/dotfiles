let mapleader = " "

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
call plug#end()

set title
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set showcmd " show the command while typing it
set noruler
set laststatus=0
set cursorline

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocomplete:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over Visual Blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable while writing prose:
	map <leader>f :Goyo \| set linebreak<CR>
" Spellcheck set to <leader>o, 'o' for orthography:
	map <leader>o :setlocal spell! spelllang=en_us<CR>
	map <leader>O :setlocal spell! spelllang=de_de<CR>
" Split open at the bottom and right, better than the vim defaults
	set splitbelow splitright

" Nerdtree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTREE.isTabTree()) | q | endif
	if has('nvim')
		let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
	else
		let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
	endif

" Shortcutting split navigation saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck
	map <leader>s :!clear && shellcheck -x %<CR>

" Replace all is aliased th S
	nnoremap S :%s//g<Left><Left>

" Compile Document, groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "%:p"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Run a cleaning script whenever close out of .tex files
	autocmd Vimleave *.tex !texclear %

" Ensure files are read as intended:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown', '.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at endof file on save.
	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks; setsid -f dwmblocks }

set bg=dark
let s:bg = 0
function! ToggleBackground()
	if s:bg == 0
		let s:bg = 1
		set bg=light
	else
		let s:bg = 0
		set bg=dark
	endif
endfunction
nnoremap <leader>b :call ToggleBackground()<CR>

set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_contrast_light='hard'
let g:gruvbox_contrast_dark='hard'

colorscheme gruvbox

" airline configuration
let g:airline_theme='gruvbox'

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''
let g:airline_symbols.branch=''
let g:airline_symbols.crypt=''
let g:airline_symbols.readonly=''

let g:airline_symbols.colnr=', '
let g:airline_symbols.linenr='☰ '
let g:airline_symbols.maxlinenr=''

let g:airline_symbols.spell='Ꞩ'
let g:airline_symbols.dirty='⚡'
let g:airline_symbols.paste='ρ'
let g:airline_symbols.notexists='Ɇ'
let g:airline_symbols.whitespace='Ξ'
