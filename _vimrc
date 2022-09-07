
"file encoding
set fileencodings=utf8,ucs-bom,gb18030,gbk,gbgb2312,cp936
set termencoding=utf-8
set encoding=utf-8

"auto syntax highlight
syntax on

colorscheme koehler

"search settings
set hlsearch
set incsearch

"detact filetype
filetype on
set history=100

"display line number
set number

"highlight current line
set cursorline

"enable mouse
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"display bracket match
set showmatch
set showmode 

"indent settings
set softtabstop=4
set shiftwidth=4
set tabstop=4
set autoindent
set expandtab

"code fold
set foldenable
set foldmethod=syntax
set foldlevel=100

"paste mode setting

"display space and tab chars
set listchars=tab:>-,trail:-

"display position of  status column and cursor
set laststatus=2
set ruler

" showmatch for begin-end in verilog
runtime macros/matchit.vim
let b:match_words='\<begin\>:\<end\>'
let b:match_words='\<function\>:\<endfunction\>'
let b:match_words='\<task\>:\<endtask\>'
let b:match_words='\<case\>:\<endcase\>'
let b:match_words='\<module\>:\<endmodule\>'

function! CleverTab()
    let col = col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-N>"
    endif
endfunction
 
function! AutoPopup()
    let col = col('.')-1
    echo getline('.')[col-1]
    if !col || getline('.')[col-1] !~ '\k' || v:char =~ '\s'
        return 0
    else
        call feedkeys("\<c-n>",'i')
    endif
endfunction

set autoread 

" auto change current directory to the path of opened file
set autochdir

" auto-complete
set completeopt=menuone,noselect,noinsert
",noselect
set shortmess+=c
au! InsertCharPre <buffer> call AutoPopup()

" key mapping
noremap <C-g> <C-]>
inoremap <F2> <ESC>:w<CR>i<Right>
inoremap <Tab> <C-R>=CleverTab()<CR>
nnoremap <F2> :w<CR>
vnoremap gd y/<C-r>0<CR>
nnoremap <leader>env :sp ~/.vimrc<cr>
nnoremap <leader><leader> :noh<cr>
nnoremap <A-PageDown> :bnext<cr>
nnoremap <A-PageUp> :bprevious<cr>

" statusline setting
set laststatus=2
function! CurrentMode()
    let l:mode = mode()
    if l:mode == 'n'
        return 'NORMAL'
    elseif l:mode == 'v' || l:mode == 'V' || l:mode =~ ''
        return 'VISUAL'
    elseif l:mode == 'i'
        return 'INSERT'
    elseif l:mode == 'r' || l:mode == 'R'
        return 'REPLACE'
    elseif l:mode == 'c'
        return 'COMMAND-LINE'
    elseif l:mode == "s"
        return 'SELECTION-MOUSE'
    else
        return l:mode
    endif
endfunction

function! Buf_total_num()
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction
function! File_size(f)
    let l:size = getfsize(expand(a:f))
    if l:size == 0 || l:size == -1 || l:size == -2
        return ''
    endif
    if l:size < 1024
        return l:size.' bytes'
    elseif l:size < 1024*1024
        return printf('%.1f', l:size/1024.0).'k'
    elseif l:size < 1024*1024*1024
        return printf('%.1f', l:size/1024.0/1024.0) . 'm'
    else
        return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
    endif
endfunction

set statusline=%9*\ %{CurrentMode()}\ %*
set statusline+=%1*\ %f\ %<%*
set statusline+=%4*\ Size:\ %{File_size(@%)}\ %*
set statusline+=%5*\ Type:\ %Y\ %*
set statusline+=%3*%r%m%*
set statusline+=%7*%=%*
set statusline+=%2*\ Buffer:\ %n\ of\ %{Buf_total_num()}\ %*
set statusline+=%6*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-8.(%l:%c%V%)%*
set statusline+=%9*\ %P\ %*
" default bg for statusline is 236 in space-vim-dark
hi User1 cterm=None ctermfg=White ctermbg=Blue
hi User2 cterm=None ctermfg=White ctermbg=Magenta
hi User3 cterm=None ctermfg=White ctermbg=Brown
hi User4 cterm=None ctermfg=White ctermbg=Green
hi User5 cterm=None ctermfg=White ctermbg=Red
hi User6 cterm=None ctermfg=White ctermbg=Cyan
hi User7 cterm=None ctermfg=White ctermbg=Gray
hi User8 cterm=None ctermfg=White ctermbg=Green
hi User9 cterm=Bold ctermbg=White ctermbg=Yellow
hi PmenuSel ctermbg=blue
hi Pmenu ctermbg=Cyan

" Directory Tree
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize=18
let g:netrw_browse_split=4

"autocmd FileType verilog set makeprg=nLint\ -f\ filelist\ -2001\ -sort\ s\ -out\ screen
autocmd FileType verilog source ~/.vim/snippet/verilog.snippet
autocmd FileType verilog set makeprg=iverilog\ -y\ .\ -g2001\ %
autocmd FileType verilog set dictionary=/usr/share/vim/vim82/syntax/verilog.vim
autocmd FileType c       set dictionary=/usr/share/vim/vim82/syntax/c.vim
autocmd FileType cpp     set dictionary=/usr/share/vim/vim82/syntax/cpp.vim
autocmd FileType verilog set complete+=k
autocmd FileType c,cpp   set complete+=k
autocmd BufWritePost $MYVIMRC source $MYVIMRC

