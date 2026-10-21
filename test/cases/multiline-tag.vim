" Lines after a multiline start tag or empty tag ending with '>' or '/>'
let g:test_flatten = 1

function! Check()
  " Indent of each line, as when typing it
  for lnum in range(2, line('$'))
    let v:lnum = lnum
    try
      call ExpectEqual(GetSvelteIndent(), indent(lnum), 'indent at line '.lnum)
    catch
      call Fail('line '.lnum.': '.v:exception)
    endtry
  endfor
endfunction
