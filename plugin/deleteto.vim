" deleteto.vim - Delete up to a certain character
" Author:       Rich Russon (flatcap) <rich@flatcap.org>
" Website:      https://flatcap.org
" Copyright:    2014-2015 Richard Russon
" License:      Same as vim, see :help license
" Version:      1.0

function! s:go(...)
	if (a:0 == 2)
		let [start, stop] = [a:1, a:2]
	else
		let [start, stop] = [line("'["), line("']")]
	endif

	let char = nr2char(getchar())
	execute start.','.stop.'s!\V\^\(\[^'.char.']\*'.char.'\)\{,'.v:count1.'\}'
endfunction

xnoremap <silent> <Plug>DeleteToV :<C-U>call <SID>go(line("'<"),line("'>"))<CR>
nnoremap <silent> <Plug>DeleteToM :<C-U>set opfunc=<SID>go<CR>g@
nnoremap <silent> <Plug>DeleteToA :<C-U>call <SID>go(1,line('$'))<CR>
nnoremap <silent> <Plug>DeleteToL :<C-U>call <SID>go(line('.'),line('.'))<CR>

" Four mappings for the commands
"       DeleteToV visual
"       DeleteToM motion
"       DeleteToA all the file
"       DeleteToL line (single)

xmap du <plug>DeleteToV
nmap du <plug>DeleteToM
nmap du <plug>DeleteToL
nmap dU <plug>DeleteToA

