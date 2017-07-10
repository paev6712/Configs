
:set ai
:set si
:set nu
:set ru
:set nowrap
:set showmatch
:set tabstop=4
:set shiftwidth=4
:set background=dark
:set ruler
:set hlsearch
:set incsearch

:fu EnableDiffHighlights()
:  hi DiffAdd term=bold ctermbg=4
:  hi DiffChange term=bold ctermbg=5
:  hi DiffDelete term=bold cterm=bold ctermfg=4 ctermbg=6
:  hi diffText term=reverse cterm=bold ctermbg=1
:endfunction

:fu DisableDiffHighlights()
:  hi clear DiffAdd
:  hi clear DiffChange
:  hi clear DiffDelete
:  hi clear DiffText
:endfunction

nmap <C-h> :/<C-R>=expand("<cword>")<CR><CR>
nmap <C-y> :normal ]cdp<CR><CR>

autocmd FileType conf setlocal textwidth=80
autocmd BufRead *.spec setlocal textwidth=80

" Set up ctags/ cscope
set csprg=/usr/bin/cscope
set tags=$FROOT/cscope/tags,tags
so $HOME/configs/.vim/plugin/cscope_maps.vim

" Remap window navigation
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-h> <C-W><C-H>
nnoremap <C-l> <C-W><C-l>

" Remap window resizing
nnoremap = 5<C-w>+
nnoremap - 5<C-w>-
nnoremap + 5<C-w>>
nnoremap _ 5<C-w><
nnoremap <silent> <C-+> :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <C--> :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <C-=> <C-w>=

" Make new splits open to the right/ below current
set splitbelow
set splitright

" Map caps lock to esc
inoremap jk <Esc>

" Map capital navigation to jump farther
nnoremap <S-j> 5j
nnoremap <S-k> 5k
nnoremap <S-h> 5h
nnoremap <S-l> 5l
