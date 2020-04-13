if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

if !has('nvim')
  setlocal matchpairs+=<:>
endif

if exists("loaded_matchit")
  let b:match_ignorecase = 1
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
        \ '{#\(if\|each\)[^}]*}:{\:else[^}]*}:{\/\(if\|each\)},' .
        \ '{#await[^}]*}:{\:then[^}]*}:{\/await},'
endif

" Indent correctly with template string for vim-javascript/builtin
" indentexpr
let b:syng_str = '^\%(.*template\)\@!.*string\|special'
let b:syng_strcom = '^\%(.*template\)\@!.*string\|comment\|regex\|special\|doc'

function! GetSvelteTag()
  let lnum = getcurpos()[1]
  let cursyns = s:SynsSOL(lnum)
  let syn = get(cursyns, 0, '')

  if syn =~ 'SvelteTemplate'
    let tag = 'template'
  elseif syn =~ 'SvelteScript'
    let tag = 'script'
  elseif syn =~ 'SvelteStyle'
    let tag = 'style'
  else
    let tag = ''
  endif

  return tag
endfunction
