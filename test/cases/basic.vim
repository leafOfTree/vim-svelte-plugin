let g:test_flatten = 1
packadd matchit

function! Check()
  " Jump between tags with % by matchit. Use :normal for its mapping
  call cursor(1, 2)
  normal %
  call ExpectEqual(getline('.'), '</script>', 'after % from <script>')
  " Default key mapping for devdocs
  call ExpectEqual(maparg('<F1>', 'n') =~# 'OpenDevDocs', 1, '<F1> mapping')
  " Visual mode needs <Cmd>
  call ExpectEqual(maparg('<F1>', 'x') =~# 'OpenDevDocs',
        \ has('patch-8.2.1978') || has('nvim-0.5'), '<F1> visual mapping')
  call ExpectEqual(maparg('<F1>', 'o'), '', '<F1> operator-pending mapping')
  " Undo settings and mappings when filetype changes
  setlocal filetype=text
  call ExpectEqual(maparg('<F1>', 'n'), '', '<F1> mapping after undo')
  call ExpectEqual(exists('b:match_words'), 0, 'b:match_words after undo')
endfunction
