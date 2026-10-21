" g:vim_svelte_plugin_config replaces script syntax and initial_indent, and
" keeps style syntax from g:vim_svelte_plugin_use_sass
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_has_init_indent = 0
let g:vim_svelte_plugin_config = {
      \ 'syntax': {'script': 'typescript'},
      \ 'initial_indent': ['script', 'style'],
      \}
let g:test_flatten = 1

function! Check()
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectSyntax('number', 'typescriptPredefinedType')
  call ExpectBlock('$a: 1px', 'style', 'scss', 'cssScssSvelteStyle')
  call ExpectIndentEachLine()
endfunction
