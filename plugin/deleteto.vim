" deleteto.vim - Delete up to a certain character
" Author:       Rich Russon (flatcap) <rich@flatcap.org>
" Website:      https://flatcap.org
" Copyright:    2014-2015 Richard Russon
" License:      GPLv3 <http://fsf.org/>
" Version:      1.0

if (exists ('g:loaded_deleteto') || &cp || (v:version < 700))
	finish
endif
let g:loaded_deleteto = 1

function! s:delete_to (start, stop, count, char)
	let l:esc_char = escape (a:char, '!\')
	let l:cmd = a:start . ',' . a:stop . 's!\V\^\(\[^' . l:esc_char . ']\*' . l:esc_char . '\)\{,' . a:count . '\}!!'
	execute l:cmd
endfunction

function! s:go (...)
	if (a:0 == 2)
		let [l:start, l:stop] = [a:1, a:2]
	else
		let [l:start, l:stop] = [line ('''['), line (''']')]
	endif

	let l:char = nr2char (getchar())
	call s:delete_to (l:start, l:stop, v:count1, l:char)
endfunction

function! s:set_up_mappings()
	nnoremap <silent> <Plug>DeleteToA :<C-U>call <SID>go (1, line ('$'))<CR>
	nnoremap <silent> <Plug>DeleteToL :<C-U>call <SID>go (line ('.'), line ('.'))<CR>
	nnoremap <silent> <Plug>DeleteToM :<C-U>set opfunc=<SID>go<CR>g@
	xnoremap <silent> <Plug>DeleteToV :<C-U>call <SID>go (line ('''<'), line ('''>'))<CR>

	" Four mappings for the commands
	"       DeleteToA all the file
	"       DeleteToL line (single)
	"       DeleteToM motion
	"       DeleteToV visual
	if (get (g:, 'deleteto_create_mappings', 1))
		nmap dU  <Plug>DeleteToA
		nmap duu <Plug>DeleteToL
		nmap du  <Plug>DeleteToM
		xmap du  <Plug>DeleteToV
	endif
endfunction


call s:set_up_mappings()

