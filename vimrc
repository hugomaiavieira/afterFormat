" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.

set ts=4
set shiftwidth=4
set et

if has("autocmd")
  filetype indent on
  autocmd FileType python set complete+=k dictionary+=~/.pydiction iskeyword+=.,(
  "autocmd FileType python set omnifunc=pythoncomplete#Complete "autocomplete in python scripts
  "autocmd filetype python set textwidth=79
  "autocmd FileType python nnoremap <C-c> :if getline(".")[searchpos('#','',line('.'))[1]] != '#' \| execute 'normal 0i#' \| else \| s/#// \| endif<esc><cr>
  autocmd BufRead,BufWrite *.html set filetype=html
  autocmd FileType eruby set tabstop=2 shiftwidth=2
  autocmd FileType html set tabstop=2 shiftwidth=2
  autocmd FileType ruby set tabstop=2 shiftwidth=2
  autocmd BufRead,BufWrite *.tt set ft=ruby
  "autocmd filetype python set tabstop=4 shiftwidth=4
  autocmd BufRead,BufWrite *.zcml set filetype=xml
  autocmd BufRead,BufWrite *.css.dtml set ft=css
  "autocmd BufRead,BufWrite Makefile set noet
  autocmd BufRead,BufWrite *.story set ts=2
  autocmd BufRead,BufNewFile *.wiki setfiletype Wikipedia
  autocmd BufRead,BufNewFile *.wikipedia.org* setfiletype Wikipedia
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		    " Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
set mouse=a		    " Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"set expandtab "set all tabs to spaces
"set tabstop=4 "when types <TAB> it puts 4 spaces
set number "show the line numbers
set incsearch
set hls
set sc "show command
set title
set ruler
set autoread
"set shiftwidth=4 "when typed >>/<< it goes 4 spaces ahead/back
set smartindent "indent the new lines as the previous
set laststatus=2 "show a status bar, with filename and etc

nnoremap <C-Right> :tabnext<CR>
nnoremap <C-Left>  :tabprevious<CR>
nnoremap <C-t>     :tabnew

