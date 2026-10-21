" g:vim_svelte_plugin_config with syntax in blocks, initial indent only for
" script, attribute and foldexpr
let g:vim_svelte_plugin_config = {
      \ 'syntax': {
      \   'template': ['pug'],
      \   'script': ['javascript', 'typescript', 'coffee'],
      \   'style': ['css', 'less', 'scss', 'sass'],
      \ },
      \ 'initial_indent': ['script'],
      \ 'attribute': 1,
      \ 'foldexpr': 1,
      \}

function! Check()
  call ExpectBlock('p(class="a")', 'template', 'pug', 'pugSvelteTemplate')
  call ExpectBlock("let name = 'world'", 'script', 'javascript', 'javascriptSvelteScript')
  call ExpectBlock('let count', 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectSyntax('number', 'typescriptPredefinedType')
  call ExpectBlock("greeting = 'Hello'", 'script', 'coffee', 'coffeeSvelteScript')
  call ExpectBlock('Hello {name}', 'template', 'html', 'htmlSvelteTemplate')
  call ExpectBlock('width: @w', 'style', 'less', 'cssLessSvelteStyle')
  call ExpectBlock('margin: $a', 'style', 'scss', 'cssScssSvelteStyle')
  call ExpectBlock('color: red', 'style', 'sass', 'cssSassSvelteStyle')
  call ExpectEqual(&l:foldmethod, 'expr', 'foldmethod')
  call ExpectEqual(synIDattr(synIDtrans(hlID('svelteKey')), 'name'), 'Type', 'attribute highlight')
  call ExpectIndentEachLine()
endfunction
