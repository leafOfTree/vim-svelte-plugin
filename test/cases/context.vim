" OnChangeSvelteSubtype() is called when subtype under cursor changes. It's
" defined before the plugin is loaded
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1
let g:test_flatten = 1
let g:test_changes = []

function! OnChangeSvelteSubtype(subtype)
  call add(g:test_changes, a:subtype)
endfunction

function! Check()
  for lnum in [2, 3, 5, 8, 2]
    call cursor(lnum, 1)
    doautocmd CursorMoved
  endfor
  call ExpectEqual(g:test_changes,
        \ ['typescript', 'html', 'scss', 'typescript'], 'subtype changes')
  call cursor(2, 1)
  call ExpectBlock('let a', 'script', 'typescript', 'typescriptSvelteScript')
endfunction
