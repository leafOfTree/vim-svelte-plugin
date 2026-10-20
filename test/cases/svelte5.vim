" Svelte 5 runes, event attributes, snippets, @render and @const
let g:test_flatten = 1

function! Check()
  call ExpectSyntax('count++', 'svelteExpression')
  call ExpectSyntax('{doubled}', 'svelteExpression')
  call ExpectSyntax('snippet', 'svelteBlockKeyword')
  call ExpectSyntax('@render', 'svelteAtTags')
  call ExpectSyntax('@const', 'svelteAtTags')
  call ExpectTag(30, 'template')
endfunction
