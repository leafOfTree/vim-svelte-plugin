if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Indent correctly with template string for vim-javascript/builtin
" indentexpr
let b:syng_str = '^\%(.*template\)\@!.*string\|special'
let b:syng_strcom = '^\%(.*template\)\@!.*string\|comment\|regex\|special\|doc'

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . " | " : "") .
      \ "unlet! b:syng_str b:syng_strcom"

if !has('nvim')
  setlocal matchpairs+=<:>
  let b:undo_ftplugin .= " | setlocal matchpairs<"
endif

if exists("loaded_matchit")
  let b:match_ignorecase = 1
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
        \ '{#\(if\|each\)[^}]*}:{\:else[^}]*}:{\/\(if\|each\)},' .
        \ '{#await[^}]*}:{\:then[^}]*}:{\/await},'
  let b:undo_ftplugin .= " | unlet! b:match_ignorecase b:match_words"
endif

if executable('npx') && !empty(globpath(&runtimepath, 'compiler/svelte-check.vim'))
  compiler svelte-check
  let b:undo_ftplugin .= " | compiler make"
endif

if !exists(':Open')
  function! s:Open(arg)
    let cmd = ''
    if has('mac')
      let cmd = 'open'
    endif
    if has('linux')
      let cmd = 'xdg-open'
    endif
    if has('win32')
      let cmd = 'start'
    endif
  
    execute '!'.cmd.' "'.a:arg.'"'
  endfunction

  command -nargs=1 Open call <SID>Open(<q-args>)
endif

function! s:OpenDevDocs() range
  if mode() =~# "[vV\<C-v>]" && exists('*getregion')
    let text = join(getregion(getpos('v'), getpos('.')))
  else
    let text = expand('<cword>')
  endif
  
  " Remove special symbols
  let clean_text = substitute(text, '[#@$%^&*(){}[\]<>]', '', 'g')
  
  let filetype = &filetype
  execute 'Open https://devdocs.io?q='.filetype.' '.clean_text
endfunction

let s:open_devdocs = svelte#GetConfig('open_devdocs', '<F1>')
if !empty(s:open_devdocs)
  execute 'noremap <buffer> '.s:open_devdocs.' <Cmd>call <SID>OpenDevDocs()<CR>'
  let b:undo_ftplugin .= " | exe 'unmap <buffer> ".s:open_devdocs."'"
endif
