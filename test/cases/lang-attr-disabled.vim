" Without the language enabled, lang in single quotes stays in the default
" language as before, while lang="..." uses its own block
function! Check()
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectBlock('color: red', 'style', 'css', 'cssSvelteStyle')
  call ExpectBlock('color: red', 'style', 'scss', 'cssScssSvelteStyle')
endfunction
