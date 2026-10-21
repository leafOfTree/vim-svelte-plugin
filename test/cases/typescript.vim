" <script lang="ts"> without g:vim_svelte_plugin_use_typescript is
" highlighted and indented as JavaScript
let g:test_flatten = 1

function! Check()
  call ExpectBlock("const name = 'world'", 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectSyntax("'world'", 'javaScriptStringS')
  call ExpectSyntax('function', 'javaScriptFunction')
endfunction
