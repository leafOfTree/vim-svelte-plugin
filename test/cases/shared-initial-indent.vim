" initial_indent by tag.syntax, not for other syntax in the same tag
let g:vim_svelte_plugin_config = {
      \ 'syntax': {'style': ['css', 'scss']},
      \ 'initial_indent': ['style.scss'],
      \}
let g:test_flatten = 1

function! Check()
  call ExpectIndentEachLine()
endfunction
