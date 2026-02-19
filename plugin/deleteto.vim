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

function! s:delete_to (start, stop, char, count) abort
	let l:esc_class = escape (a:char, '\^-]')
	let l:esc_delim = escape (a:char, '!\')
	let l:cmd = 'keeppatterns ' . a:start . ',' . a:stop . 's!\V\^\(\[^' . l:esc_class . ']\*' . l:esc_delim . '\)\{,' . a:count . '\}!!'
	execute l:cmd

	" if vim-repeat is installed (https://github.com/tpope/vim-repeat)
	let b:dt_start = a:start
	let b:dt_stop  = a:stop
	let b:dt_char  = a:char
	let b:dt_count = a:count
	silent! call repeat#set("\<Plug>DeleteToRepeat", a:count)
endfunction

function! s:go (...) abort
	if (a:0 == 1)
		" Motion
		let l:start = line ("'[")
		let l:stop  = line ("']")
		let l:char  = nr2char (getchar())
		let l:count = v:count1
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

function! s:set_up_mappings() abort
	nnoremap <silent> <Plug>DeleteToA      :<C-U>call <SID>go(1, line ('$'))<CR>
	nnoremap <silent> <Plug>DeleteToL      :<C-U>call <SID>go(line ('.'), line ('.'))<CR>
	nnoremap <silent> <Plug>DeleteToM      :<C-U>set opfunc=<SID>go<CR>g@
	xnoremap <silent> <Plug>DeleteToV      :<C-U>call <SID>go(line ("'<"), line ("'>"))<CR>
	nnoremap <silent> <Plug>DeleteToRepeat :<C-U>call <SID>delete_to (get(b:, 'dt_start', 1), get(b:, 'dt_stop', line('$')), get(b:, 'dt_char', ''), v:count > 0 ? v:count : get(b:, 'dt_count', 1))<CR>

	if (get (g:, 'deleteto_create_mappings', 1))
		if empty(maparg('dU',  'n'))
			nnoremap dU  <Plug>DeleteToA
		endif
		if empty(maparg('duu', 'n'))
			nnoremap duu <Plug>DeleteToL
		endif
		if empty(maparg('du',  'n'))
			nnoremap du  <Plug>DeleteToM
		endif
		if empty(maparg('du',  'x'))
			xnoremap du  <Plug>DeleteToV
		endif
	endif

	command! -range=% -nargs=+ DeleteTo call <SID>go(<line1>, <line2>, <f-args>)
endfunction


call s:set_up_mappings()

