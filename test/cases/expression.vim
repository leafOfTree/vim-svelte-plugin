" Top-level tags with '>' in attribute expressions
let g:test_flatten = 1

function! Check()
  for lnum in [5, 6, 9, 11, 18, 20]
    call ExpectTag(lnum, 'template')
  endfor
  call ExpectSyntax('reset()', 'svelteExpression')
  normal! G
  call ExpectSyntax('Many', 'svelteExpression')
endfunction
