" Uses syntax plugins in test/deps
let g:vim_svelte_plugin_use_pug = 1
let g:vim_svelte_plugin_use_less = 1
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_use_coffee = 1
let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_highlight_svelte_attr = 1
let g:vim_svelte_plugin_use_foldexpr = 1

" Block tag, subtype by lang="..." and block group with css prefix for
" emmet-vim
function! Check()
  call ExpectBlock('a="adf"', 'template', 'html', 'htmlSvelteTemplate')
  call ExpectBlock('// Highlight everything', 'template', 'pug', 'pugSvelteTemplate')
  call ExpectBlock("let greeting = 'Hello'", 'script', 'javascript', 'javascriptSvelteScript')
  call ExpectBlock('# Assignment', 'script', 'coffee', 'coffeeSvelteScript')
  call ExpectBlock('font-size: 2em', 'style', 'css', 'cssSvelteStyle')
  call ExpectBlock('$a: 100px', 'style', 'scss', 'cssScssSvelteStyle')
  call ExpectBlock('$w: 128px', 'style', 'sass', 'cssSassSvelteStyle')
  call ExpectBlock('@list: 10 12', 'style', 'less', 'cssLessSvelteStyle')
endfunction
