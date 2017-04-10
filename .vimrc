"""""""""""""""""""""""""""""""""""""""""
"Author=> Chris Olin (www.chrisolin.com)
"
"Purpose => vim configuration for cygwin (work)
"
"Created date: 08-16-2012
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" => Initialization"
"""""""""""""""""""""""""""""
"Source plugins
source $HOME/.vim/bundle/vim-git-aware/vimrc.template
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"""""""""""""""""""""""""""""
" => The Basics
"""""""""""""""""""""""""""""
" SSH ONLY ISSUE
" DO NOT ENABLE THE GitBranch() FUNCTION ON LINE 89!
" It causes strange charaters, like ^[OA, to appear
" when scrolling or editing a file in vi.
"
set nocompatible smd ar si noet bg=dark sts=0 autoindent noexpandtab ts=4 sw=4
syntax on
filetype on
filetype plugin indent on

"Insert datestamp
:nnoremap <F5> "=strftime("%c")<CR>P
:inoremap <F5> <C-R>=strftime("%c")<CR>

" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

"Quick switching through buffer tabs
:nnoremap <F11> :tabp<CR>
:nnoremap <F12> :tabn<CR>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "-"
let g:mapleader = "-"

" Fast saving
nmap <leader>w :w!<cr>

" Return to last edit position (You want this!) *N*
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" |
      \ endif

""""""""""""""""""""""""""""""
" => Useful stuff
""""""""""""""""""""""""""""""
"copy to clipboard
:nnoremap <leader>c :'<,'>w !xclip -i -selection clipboard,primary<cr>

"remove ^M dos line endings
:nnoremap <leader>m :%s///<cr>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" I don't like backup/temp files scattered all over the place
set backup
set backupdir=/tmp/
set backupskip=/tmp/*
set directory=/tmp/
set writebackup

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"      set mouse=a
"      endif

""""""""""""""""""""""""""""""
" => Functions
""""""""""""""""""""""""""""""
" Just a simple substitute. Be sure to change this to your own home directory.
function! CurDir()
return substitute(getcwd(), '$HOME', "~", "g")
endfunction

" Just a blantantly obvious reminder when we're in paste mode
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    en
    return ''
endfunction

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L%{GitBranch()}
" set statusline=\ %{HasPaste()}%f\ \ %{&ff}%y%m%r%h\ %w\ CWD:\ %r%{CurDir()}%h\ \ Line:\ %l/%L
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

let cwd = getcwd()
let cwfp = expand("%:p:h")

set statusline=
set statusline +=%1*\%{HasPaste()}\ %*                  "got paste mode?
set statusline +=%4*%{&ff}%*                            "file format
set statusline +=%3*%y%*                                "file type
set statusline +=%6*\ %{GitBranch()}                    "git branch, if it exists
if cwd != cwfp                                          "this is to get rid of absolute path spam
    set statusline +=%1*\ CWD:\ \%<%{CurDir()}          "current working directory
en
    set statusline +=%5*\ File:\ \%F%*                  "current file and absolute path
set statusline +=%2*%m%*                                "modified flag
set statusline +=%1*%=%5l%*                             "current line
set statusline +=%2*/%L%*                               "total lines
"set statusline +=%1*%4v\ %*                            "virtual column number
set statusline +=%2*\ 0x%04B\ %*                        "character under cursor

"TERM variable must be set to xterm-256color or another term that supports 256 colors, otherwise this will not work
hi User1 ctermfg=208
hi User2 ctermfg=196
hi User3 ctermfg=27
hi User4 ctermfg=46
hi User5 ctermfg=226
hi User6 ctermfg=3

"""""""""""""""""""""""""""""""""
" => Mutt
"""""""""""""""""""""""""""""""""
"I don't like long, endless lines when typing e-mails.
au BufRead /tmp/mutt-* set tw=75
"Except I have a habit going back and rewording sentences and VIM doesn't automagically adjust lines. ,r will now reformat the current paragraph!
nmap <leader>r gqap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""
" => Insert modeline
"""""""""""""""""""""""""""""""""""""""""""""""
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
" Use <leader>ml to append.

function! AppendModeline()
    let l:modeline = printf("# vim:smd:ar:si:noet:bg=dark:sts=0:ts=%d:sw=%d ",
          \ &tabstop, &shiftwidth)
    let l:modeline = substitute(l:modeline, "%s", l:modeline, "")
    let l:line = line (".")
    call append(l:line - 1, l:modeline)

endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

function! AppendHeader()
    let l:line = line (".")
    let l:line9 = append(l:line - 1, "########################################################")
		let l:line7 = append(l:line - 1, "# license: ")
		let l:line6 = printf("# created date: %s",
					\ strftime("%m-%d-%Y"))
		call append(l:line - 1, l:line6)
		let l:line5 = append(l:line - 1, "# purpose: ")
		let l:line4 = append(l:line - 1, "# author: Chris Olin - http://chrisolin.com")
		let l:line3 = append(l:line - 1, "# file: ")
		let l:line2 = printf("# vim:smd:ar:si:noet:bg=dark:sts=0:ts=%d:sw=%d",
					\	&tabstop, &shiftwidth)
		call append(l:line - 1, l:line2)
		let l:line1 = append(l:line - 1, "########################################################")
    let l:line2 = substitute(l:line2, "%s", l:line2, "")


endfunction
nnoremap <silent> <Leader>hd :call AppendHeader()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype specific hacks
""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert header
""""""""""""""""""""""""""""""""""""""""""""""""
" All the fun is in this file so we can comment one line to disable it.

" This shit is actually really irritating, so I'm commenting it out

"source $HOME/.vimheader
