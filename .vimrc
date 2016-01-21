if v:progname =~? "evim"
  finish
endif

set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-generator'

Plugin 'L9'
Plugin 'FuzzyFinder'

" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'tpope/vim-fugitive' 		" Git integration

Plugin 'bling/vim-airline'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'

Plugin 'sjl/gundo.vim'

Plugin 'oplatek/Conque-Shell'
Plugin 'majutsushi/tagbar'

call vundle#end() 

fun! CmdAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call CmdAlias( "W", "w")
call CmdAlias( "Q", "q")
call CmdAlias( "ct", "ConqueTerm")

function! CleanClose(tosave)
    if (a:tosave == 1)
        w!
    endif
    
    let todelbufNr = bufnr("%")
    let newbufNr = bufnr("#")

    if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
        exe "b".newbufNr
    else
        bnext
    endif

    if (bufnr("%") == todelbufNr)
        new
    endif
    
    exe "bd".todelbufNr
endfunction

map  :call CleanClose(0)<cr>

let NERDTreeShowHidden=1

map <C-e> <plug>NERDTreeTabsToggle<CR>
" map <C-e> :NERDTreeTabsToggle<CR>

nmap Ol :TagbarToggle<CR>
imap Ol :TagbarToggle<CR>i

" jk tip + save
imap jk <Esc>:w<CR>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set nowb
set noswapfile
set nowrap

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq
inoremap <C-U> <C-G>u<C-U>

filetype plugin on

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=120

  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" ----------

" C-Up
map [1;5A :cp<Cr>zvzz:cc<Cr>
" C-Down
map [1;5B :cn<Cr>zvzz:cc<Cr>
" C-Left
map [1;5D :bNext<Cr>
" C-Right
map [1;5C :bnext<Cr>

map <F4> :A<Cr>

command! -nargs=1 Silent
    \ | execute ':silent '.<q-args>
    \ | execute ':redraw!'

map <F5> :Silent !rmbuild<Cr>
map <F7> :Silent !cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
	    	\ -DCMAKE_CXX_FLAGS="-O3 -g -ggdb -ggdb3 -Wall
		\ -fno-omit-frame-pointer -time" ../<Cr>
map <F8> :wall \| Silent make -j3<Cr>

map <F12> :Gblame<Cr>
map <S-F12> :Gdiff<Cr>
map <S-F11> :Glog<Cr>

" gundo
let g:gundo_right = 1
let g:gundo_close_on_revert = 1

nnoremap <C-u> :GundoToggle<CR>

" doxygen
map <C-d> :Dox<Cr>
imap <C-d> :Dox<Cr>

nmap <space> :YcmCompleter GoTo<CR>
nmap <C-a> :YcmDiags<CR>

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 1

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" nmap  :!<CR>
set pastetoggle=<F2>

let g:UltiSnipsExpandTrigger="<c-z>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]

let g:airline_theme                       = 'dark'

let g:airline_powerline_fonts             = 1
let g:airline_detect_iminsert             = 1

" let g:airline_symbols.readonly            = '\u2B64'
" let g:airline_symbols.linenr              = '\u2B61'

let g:nerdtree_tabs_open_on_console_startup = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

let leader = exists('g:mapleader') ? g:mapleader : '\'

set laststatus=2

nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt 
nmap <leader>4 4gt 
nmap <leader>5 5gt 
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt

set noautochdir

" 256 colors
set t_Co=256

syntax on
colors mushroom

set number
set autoindent
set backspace=indent,eol,start
set hlsearch
set incsearch
set autowrite
set hidden
set switchbuf=useopen
set showfulltag

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set colorcolumn=120
hi ColorColumn ctermbg=darkred

map <C-n> :pyf /usr/share/vim/addons/syntax/clang-format-3.6.py<cr>

noremap   <buffer> l      :s,^\(\s*\)[^// \t]\@=,\1//,e<CR>:nohls<CR>zvj
noremap   <buffer> <C-l>  :s,^\(\s*\)//\s\@!,\1,e<CR>:nohls<CR>zvj
noremap   <buffer> <S-l>  *:s//\/*\0*\/<CR>:nohls<CR>

" Detect if the current file type is a C-like language.
au BufNewFile,BufRead *.c,*.h,*.hpp,*.cc,*.cpp,*.objc,*.mm call SetupForCLang()

function! RmBuild()
    echo getcwd() 
endfunction 

function! SetupForCLang()
    setlocal textwidth=120
    setlocal shiftwidth=4
    setlocal tabstop=4
    ab #b /***************************************
    ab #e <space>***************************************/
    ab #l /*------------------------------------------*/
    ab #i #include
    ab #d #define
    setlocal softtabstop=4
    setlocal expandtab
    setlocal cindent
    setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
    setlocal indentexpr=CppIndent()
    let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"
endfunction

function! CppIndent()
    let l:cline_num = line('.')
    let l:orig_indent = cindent(l:cline_num)
    if l:orig_indent == 0 | return 0 | endif
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    if l:pline =~# '^\s*template' | return l:pline_indent | endif
    if l:orig_indent != &shiftwidth | return l:orig_indent | endif
    let l:in_comment = 0
    let l:pline_num = prevnonblank(l:cline_num - 1)
    while l:pline_num > -1
        let l:pline = getline(l:pline_num)
        let l:pline_indent = indent(l:pline_num)
        if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
            let l:in_comment = 1
        elseif l:in_comment == 1
            if l:pline =~ '/\*\(.\{-}\*/\)\@!'
                let l:in_comment = 0
            endif
        elseif l:pline_indent == 0
            if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
                if l:pline =~# '^\s*namespace.*'
                    return 0
                else
                    return l:orig_indent
                endif
            elseif l:pline =~# '\\$'
                return l:orig_indent
            endif
        else
            return l:orig_indent
        endif
        let l:pline_num = prevnonblank(l:pline_num - 1)
   endwhile
   return l:orig_indent
endfunction

" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
  hi def link cppFuncDef Special
endfunction

autocmd Syntax cpp call EnhanceCppSyntax()

" Open Quickfix window automatically after running :make
augroup OpenQuickfixWindowAfterMake
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END

" Comment 
