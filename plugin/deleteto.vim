" deleteto.vim - Delete up to a certain character
" Author:       Rich Russon (flatcap) <rich@flatcap.org>
" Website:      https://flatcap.org
" Copyright:    2014-2015 Richard Russon
" License:      GPLv3 <http://fsf.org/>
" Version:      1.2

if (exists ('g:loaded_deleteto') || &cp || (v:version < 700))
	finish
endif
let g:loaded_deleteto = 1

function! s:delete_to (start, stop, char, count)
	let l:esc_char = escape (a:char, '!\')
	let l:cmd = a:start . ',' . a:stop . 's!\V\^\(\[^' . l:esc_char . ']\*' . l:esc_char . '\)\{,' . a:count . '\}!!'
	execute l:cmd

	" if vim-repeat is installed (https://github.com/tpope/vim-repeat)
	let b:dt_start = a:start
	let b:dt_stop  = a:stop
	let b:dt_char  = a:char
	silent! call repeat#set("\<Plug>DeleteToRepeat", a:count)
endfunction

function! s:go (...)
	if (a:0 == 1)
		" Motion
		let l:start = line ("'[")
		let l:stop  = line ("']")
		let l:char  = nr2char (getchar())
		let l:count = 1
	elseif (a:0 == 2)
		" All, line, visual
		let l:start = a:1
		let l:stop  = a:2
		let l:char  = nr2char (getchar())
		let l:count = v:count1
	else
		" Command
		let l:start = a:1
		let l:stop  = a:2
		let l:char  = a:3
		let l:count = (a:0 == 4) ? a:4 : 1
	endif
	call s:delete_to (l:start, l:stop, l:char, l:count)
endfunction

function! s:set_up_mappings()
	nnoremap <silent> <Plug>DeleteToA      :<C-U>call <SID>go(1, line ('$'))<CR>
	nnoremap <silent> <Plug>DeleteToL      :<C-U>call <SID>go(line ('.'), line ('.'))<CR>
	nnoremap <silent> <Plug>DeleteToM      :<C-U>set opfunc=<SID>go<CR>g@
	xnoremap <silent> <Plug>DeleteToV      :<C-U>call <SID>go(line ("'<"), line ("'>"))<CR>
	nnoremap <silent> <Plug>DeleteToRepeat :<C-U>call <SID>delete_to (b:dt_start, b:dt_stop, b:dt_char, v:count)<CR>

	if (get (g:, 'deleteto_create_mappings', 1))
		nmap dU  <Plug>DeleteToA
		nmap duu <Plug>DeleteToL
		nmap du  <Plug>DeleteToM
		xmap du  <Plug>DeleteToV
	endif

	command! -range=% -nargs=+ DeleteTo call <SID>go(<line1>, <line2>, <f-args>)
endfunction


call s:set_up_mappings()

