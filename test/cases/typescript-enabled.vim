" <script lang="ts"> with TypeScript syntax and indent
let g:vim_svelte_plugin_use_typescript = 1
let g:test_flatten = 1

function! Check()
  call ExpectBlock("const name = 'world'", 'script', 'typescript', 'typescriptSvelteScript')
  call ExpectSyntax("'world'", 'typescriptString')
endfunction
