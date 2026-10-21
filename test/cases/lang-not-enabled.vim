" Languages supported before g:vim_svelte_plugin_config but not enabled.
" They have their block without syntax, and keep indent instead of errors
" from indent functions not loaded. less uses css indent
function! Check()
  call ExpectBlock('p hello', 'template', 'pug', 'pugSvelteTemplate')
  call ExpectBlock('a = ->', 'script', 'coffee', 'coffeeSvelteScript')
  call ExpectBlock('color: blue', 'style', 'sass', 'cssSassSvelteStyle')
  call ExpectBlock('color red', 'style', 'stylus', 'cssStylusSvelteStyle')
  call ExpectBlock('color: red;', 'style', 'less', 'cssLessSvelteStyle')
  call ExpectIndentEachLine()
endfunction
