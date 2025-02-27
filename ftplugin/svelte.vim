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
if exists(':Open') == 2
  " let &keywordprg = ':Open https://devdocs.io/\#q='..&filetype
  nnoremap <buffer> <expr> <F1> '<cmd>Open https://devdocs.io/\#q='..&filetype..' '..expand('<cword>')..'<CR>'
  let b:undo_ftplugin .= " | exe 'nunmap <buffer> <F1>'"
  if exists('*getregion')
    vnoremap <buffer> <expr> <F1> '<cmd>Open https://devdocs.io/\#q='..&filetype..' '..join(getregion(getpos('v'), getpos('.')))..'<CR>'
    let b:undo_ftplugin .= " | exe 'vunmap <buffer> <F1>'"
  endif
endif
