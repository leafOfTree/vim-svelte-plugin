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

if executable('npx')
  compiler svelte-check
endif
" let &keywordprg = ':Open https://devdocs.io/\#q='..&filetype
nnoremap <buffer> <expr> <F1> '<cmd>Open https://devdocs.io/\#q='..&filetype..' '..expand('<cword>')..'<CR>'
if exists('*getregion')
  vnoremap <buffer> <expr> <F1> '<cmd>Open https://devdocs.io/\#q='..&filetype..' '..join(getregion(getpos('v'), getpos('.')))..'<CR>'
endif
