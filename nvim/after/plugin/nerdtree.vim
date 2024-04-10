let g:NERDTreeMarkedNodes = []
let g:hilines = ''
let g:hilines_idx = -1
let g:alpha = 'abcdefghijklmnopqrstuvwxyz'

function Hi(type, group)
	if g:hilines !=# ''
		if a:type ==# 'line'
			let g:hilines .=  '\|'.'\%'.line('.').'l'
		elseif a:type ==# 'nonWhiteSpace'
			let g:hilines .=  '\|'.'\(\%'.line('.').'l\&\S\)'
		endif

	else
		if a:type ==# 'line'
			let g:hilines =  '\%'.line('.').'l'
		elseif a:type ==# 'nonWhiteSpace'
			let g:hilines =  '\(\%'.line('.').'l\&\S\)'
		endif
	endif
	let g:hilines_idx = g:hilines_idx + 1

	exec 'match '.a:group.' /'.g:hilines.'/'
	exec 'normal! m'.g:alpha[g:hilines_idx]
endfunction

function ClearHi()
	exec 'match none'
	let g:hilines = ''
	exec 'delmarks a-z'
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'Mn',
       \ 'callback': 'NERDTreeMarkNode',
       \ 'quickhelpText': 'mark nodes for future editing',
       \ 'scope': 'Node' })

" call NERDTreeMarkNode(NERDTreeFileNode.GetSelected())
function! NERDTreeMarkNode(dirnode)
    if match(bufname(), "NERD_tree") != 0
        return
    endif
	call Hi('nonWhiteSpace', 'Title')
	let g:NERDTreeMarkedNodes += [a:dirnode.path.str()]
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'Mc',
       \ 'callback': 'NERDTreeClearMarks',
       \ 'quickhelpText': 'unmark all nodes',
       \ 'scope': 'all' })

function! NERDTreeClearMarks()
	call ClearHi()
	let g:NERDTreeMarkedNodes = []
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'Mx',
       \ 'callback': 'NERDTreeMarkedExec',
       \ 'quickhelpText': 'execute a shell command on all marked nodes',
       \ 'scope': 'all' })

function! NERDTreeMarkedExec()
	if empty(g:NERDTreeMarkedNodes)
		echo 'no nodes selected'
		return
	endif

	let l:in = input('cmd: ')

	let l:allFiles = ''

	for file in g:NERDTreeMarkedNodes
		let l:allFiles .= '"'.file.'" '
	endfor
	
	let l:cmd = substitute(l:in, '\s%n\(\>\|\s\)', ' '.l:allFiles, 'g')

	exec ':!'.l:cmd
	call NERDTreeClearMarks()
	NERDTreeRefreshRoot
endfunction

nnoremap <leader>nn :NERDTreeToggle<cr>
nnoremap <leader>nd :exec 'NERDTree '.getcwd()<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>nF :exec 'NERDTree '.bufname()<cr>
nnoremap <leader>nc :NERDTreeClose<cr>
nnoremap <leader>nb :NERDTreeFromBookmark<Space>
nnoremap <silent> <leader>nma :call NERDTreeMarkNode(NERDTreeFileNode.GetSelected())<cr>
nnoremap <silent> <leader>nmc :call NERDTreeClearMarks()<cr>
nnoremap <leader>nmx :call NERDTreeMarkedExec()<cr>
