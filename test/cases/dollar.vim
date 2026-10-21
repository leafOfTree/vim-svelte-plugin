" $: reactive statements and $store in script, css keywords with '-'
let g:test_flatten = 1

function! Check()
  call ExpectSyntax('$: doubled', 'svelteKeyword')
  call ExpectNoSyntax('$count', 'svelteKeyword')
  call ExpectSyntax('$: {', 'svelteKeyword')
  call ExpectSyntax('font-size', 'cssFontProp')
endfunction
