" Each key of syntax replaces the default of the same key, so style keeps
" css
let g:vim_svelte_plugin_config = {'syntax': {'script': ['typescript']}}
let g:test_flatten = 1

function! Check()
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectBlock('{count}', 'template', 'html', 'htmlSvelteTemplate')
  call ExpectBlock('color: red', 'style', 'css', 'cssSvelteStyle')
endfunction
