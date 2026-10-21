" Disable the devdocs key mapping
let g:vim_svelte_plugin_open_devdocs = ''

function! Check()
  call ExpectEqual(maparg('<F1>', 'n'), '', '<F1> mapping')
endfunction
