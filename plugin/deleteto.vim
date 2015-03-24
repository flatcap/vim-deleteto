" deleteto.vim - Delete up to a certain character
" Maintainer:   Rich Russon (flatcap) <rich@flatcap.org>
" Version:      0.1

function! s:go(...)
	if (a:0 == 2)
		let [start, stop] = [a:1, a:2]
	else
		let [start, stop] = [line("'["), line("']")]
	endif

	let char = nr2char(getchar())
	execute start.','.stop.'s!^\([^\'.char.']*\'.char.'\)\{,'.v:count1.'\}'
endfunction

xnoremap <silent> <Plug>DeleteToV :<C-U>call <SID>go(line("'<"),line("'>"))<CR>
nnoremap <silent> <Plug>DeleteToM :<C-U>set opfunc=<SID>go<CR>g@
nnoremap <silent> <Plug>DeleteToA call <SID>go(1,line('$'))<CR>
nnoremap <silent> <Plug>DeleteToL call <SID>go(line('.'),line('.'))<CR>

" Four mappings for them command
"       DeleteToV visual
"       DeleteToM motion
"       DeleteToA all the file
"       DeleteToL line (single)

xmap du <plug>DeleteToV
nmap du <plug>DeleteToM
nmap du <plug>DeleteToL
nmap dU <plug>DeleteToA

