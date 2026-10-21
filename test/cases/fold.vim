let g:vim_svelte_plugin_use_foldexpr = 1

function! Check()
  call ExpectEqual(&l:foldmethod, 'expr', 'foldmethod')
  let levels = [1, 2, 2, 3, 3, 3, 1, 1, 1, 2, 1, 1, 1, 2, 3, 2, 1]
  for lnum in range(1, len(levels))
    call ExpectFoldlevel(lnum, levels[lnum - 1])
  endfor
  " Undo when filetype changes
  setlocal filetype=text
  call ExpectEqual(&l:foldmethod, 'manual', 'foldmethod after undo')
endfunction
