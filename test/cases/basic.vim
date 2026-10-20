let g:test_flatten = 1
packadd matchit

function! Check()
  " Jump between tags with % by matchit. Use :normal for its mapping
  call cursor(1, 2)
  normal %
  call ExpectEqual(getline('.'), '</script>', 'after % from <script>')
  " Default key mapping for devdocs
  call ExpectEqual(maparg('<F1>', 'n') =~# 'OpenDevDocs', 1, '<F1> mapping')
endfunction
