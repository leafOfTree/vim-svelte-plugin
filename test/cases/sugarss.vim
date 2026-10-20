" SugarSS by lang="sss" uses sass syntax and indent (#24)
let g:vim_svelte_plugin_use_sass = 1

function! Check()
  call ExpectBlock('.a', 'style', 'sass', 'cssSassSvelteStyle')
endfunction
