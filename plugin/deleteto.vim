" deleteto.vim - Delete up to a certain character
" Author:       Rich Russon (flatcap) <rich@flatcap.org>
" Website:      https://flatcap.org
" Copyright:    2014-2026 Richard Russon
" License:      GPLv3 <http://fsf.org/>
" Version:      1.3

if exists('g:loaded_deleteto') || &cp || v:version < 700
	finish
endif
let g:loaded_deleteto = 1

function! s:getchar() abort
	if exists('*getcharstr')
		return getcharstr()
	endif
	return nr2char(getchar())
endfunction

function! s:collect(text) abort
	call add(s:yanked, a:text)
	return ''
endfunction

function! s:delete(start, stop, char, count, inclusive) abort
	let esc_class = escape(a:char, '\^-]')
	let esc_delim = escape(a:char, '!\')
	if a:inclusive
		let pat = '\V\^\(\[^' . esc_class . ']\*' . esc_delim . '\)\{,' . a:count . '\}'
	else
		let cnt = max([0, a:count - 1])
		let pat = '\V\^\(\[^' . esc_class . ']\*' . esc_delim . '\)\{,' . cnt . '\}\[^' . esc_class . ']\*\ze' . esc_delim
	endif
	if get(g:, 'deleteto_yank', 0)
		let s:yanked = []
		let cmd = 'keeppatterns ' . a:start . ',' . a:stop . 's!' . pat . '!\=s:collect(submatch(0))!'
	else
		let cmd = 'keeppatterns ' . a:start . ',' . a:stop . 's!' . pat . '!!'
	endif
	execute cmd
	if get(g:, 'deleteto_yank', 0) && !empty(s:yanked)
		call setreg('"', join(s:yanked, "\n"))
	endif

	" if vim-repeat is installed (https://github.com/tpope/vim-repeat)
	let b:dt_start = a:start
	let b:dt_stop = a:stop
	let b:dt_char = a:char
	let b:dt_count = a:count
	let b:dt_inclusive = a:inclusive
	silent! call repeat#set("\<Plug>DeleteRepeat", a:count)
endfunction

function! s:go(...) abort
	if a:0 == 1
		" Motion
		let start = line("'[")
		let stop = line("']")
		let char = s:getchar()
		let num = v:count1
	elseif a:0 == 2
		" All, line, visual
		let start = a:1
		let stop = a:2
		let char = s:getchar()
		let num = v:count1
	else
		" Command
		let start = a:1
		let stop = a:2
		let char = a:3
		let num = a:0 == 4 ? a:4 : 1
	endif
	call s:delete(start, stop, char, num, 1)
endfunction

function! s:go_until(...) abort
	if a:0 == 1
		" Motion
		let start = line("'[")
		let stop = line("']")
		let char = s:getchar()
		let num = v:count1
	elseif a:0 == 2
		" All, line, visual
		let start = a:1
		let stop = a:2
		let char = s:getchar()
		let num = v:count1
	else
		" Command
		let start = a:1
		let stop = a:2
		let char = a:3
		let num = a:0 == 4 ? a:4 : 1
	endif
	call s:delete(start, stop, char, num, 0)
endfunction

function! s:command(start, stop, ...) abort
	if a:0 < 1 || a:0 > 2
		echoerr 'DeleteTo: expected 1 or 2 arguments (CHAR [num])'
		return
	endif
	let char = a:1
	let num = 1
	if a:0 == 2
		if a:2 !~# '^\d\+$'
			echoerr 'DeleteTo: num must be a number'
			return
		endif
		let num = str2nr(a:2)
	endif
	call s:delete(a:start, a:stop, char, num, 1)
endfunction

function! s:command_until(start, stop, ...) abort
	if a:0 < 1 || a:0 > 2
		echoerr 'DeleteUntil: expected 1 or 2 arguments (CHAR [num])'
		return
	endif
	let char = a:1
	let num = 1
	if a:0 == 2
		if a:2 !~# '^\d\+$'
			echoerr 'DeleteUntil: num must be a number'
			return
		endif
		let num = str2nr(a:2)
	endif
	call s:delete(a:start, a:stop, char, num, 0)
endfunction

function! s:set_up_mappings() abort
	" DeleteTo mappings (inclusive - delete including the delimiter)
	nnoremap <silent> <Plug>DeleteToA      :<C-U>call <SID>go(1, line('$'))<CR>
	nnoremap <silent> <Plug>DeleteToL      :<C-U>call <SID>go(line('.'), line('.'))<CR>
	nnoremap <silent> <Plug>DeleteToM      :<C-U>set opfunc=<SID>go<CR>g@
	xnoremap <silent> <Plug>DeleteToV      :<C-U>call <SID>go(line("'<"), line("'>"))<CR>

	" DeleteUntil mappings (exclusive - delete up to but not including the delimiter)
	nnoremap <silent> <Plug>DeleteUntilA      :<C-U>call <SID>go_until(1, line('$'))<CR>
	nnoremap <silent> <Plug>DeleteUntilL      :<C-U>call <SID>go_until(line('.'), line('.'))<CR>
	nnoremap <silent> <Plug>DeleteUntilM      :<C-U>set opfunc=<SID>go_until<CR>g@
	xnoremap <silent> <Plug>DeleteUntilV      :<C-U>call <SID>go_until(line("'<"), line("'>"))<CR>

	" Repeat mapping (used by vim-repeat, adapts to last operation)
	nnoremap <silent> <Plug>DeleteRepeat :<C-U>call <SID>delete(get(b:, 'dt_start', 1), get(b:, 'dt_stop', line('$')), get(b:, 'dt_char', ''), v:count > 0 ? v:count : get(b:, 'dt_count', 1), get(b:, 'dt_inclusive', 1))<CR>

	if get(g:, 'deleteto_create_mappings', 1)
		if empty(maparg('dU', 'n'))
			nmap dU  <Plug>DeleteToA
		endif
		if empty(maparg('duu', 'n'))
			nmap duu <Plug>DeleteToL
		endif
		if empty(maparg('du', 'n'))
			nmap du  <Plug>DeleteToM
		endif
		if empty(maparg('du', 'x'))
			xmap du  <Plug>DeleteToV
		endif
	endif

	command! -range=% -nargs=+ DeleteTo    call <SID>command(<line1>, <line2>, <f-args>)
	command! -range=% -nargs=+ DeleteUntil call <SID>command_until(<line1>, <line2>, <f-args>)
endfunction

call s:set_up_mappings()
