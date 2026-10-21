" lang attribute in single quotes or without quotes
let g:vim_svelte_plugin_use_sass = 1

function! Check()
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectBlock('$a: 1px', 'style', 'scss', 'cssScssSvelteStyle')
endfunction
