" shiftwidth=0 uses the value of tabstop, same as shiftwidth=4 here
set shiftwidth=0 tabstop=4
let g:vim_svelte_plugin_use_foldexpr = 1
let g:test_flatten = 1

function! Check()
  call ExpectFoldlevel(2, 3)
  call ExpectFoldlevel(3, 3)
  call ExpectFoldlevel(8, 2)
  call ExpectFoldlevel(9, 3)
endfunction
