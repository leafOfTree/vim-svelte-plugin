" A language without syntax or indent file has its block, keeping indent
let g:vim_svelte_plugin_config = {'syntax': {'style': ['css', 'postcss']}}

function! Check()
  call ExpectBlock('color: red', 'style', 'postcss', 'cssPostcssSvelteStyle')
  call ExpectIndentEachLine()
endfunction
