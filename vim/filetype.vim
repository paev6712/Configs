" Resource: http://vim.wikia.com/wiki/Filetype.vim

" Check if filetype loaded by default
if exists("did_load_filetypes")
	finish
endif

" Otherwise define custom filetype
augroup filetypedetect
	au! BufRead,BufNewFile *.yang setf yang
augroup END
