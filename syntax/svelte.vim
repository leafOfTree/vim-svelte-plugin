"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: Svelte
" Maintainer: leaf <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:current_syntax") && b:current_syntax == 'svelte'
  finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:load_full_syntax = exists("g:vim_svelte_plugin_load_full_syntax")
      \ && g:vim_svelte_plugin_load_full_syntax == 1
let s:use_less = exists("g:vim_svelte_plugin_use_less")
      \ && g:vim_svelte_plugin_use_less == 1
let s:use_sass = exists("g:vim_svelte_plugin_use_sass")
      \ && g:vim_svelte_plugin_use_sass == 1
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:LoadSyntax(group, type)
  if s:load_full_syntax
    call s:LoadFullSyntax(a:group, a:type)
  else
    call s:LoadDefaultSyntax(a:group, a:type)
  endif
endfunction

function! s:LoadDefaultSyntax(group, type)
  unlet! b:current_syntax
  let syntaxPaths = ['$VIMRUNTIME', '$VIM/vimfiles', '$HOME/.vim']
  for path in syntaxPaths
    let file = expand(path).'/syntax/'.a:type.'.vim'
    if filereadable(file)
      execute 'syntax include '.a:group.' '.file
    endif
  endfor
endfunction

function! s:LoadFullSyntax(group, type)
  unlet! b:current_syntax
  exec 'syntax include '.a:group.' syntax/'.a:type.'.vim'
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load main syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/*.vim to syntax group
call s:LoadSyntax('@HTMLSyntax', 'html')

" Load svelte-html syntax
syntax include syntax/svelte-html.vim

" Avoid overload
if hlexists('cssTagName') == 0
  call s:LoadSyntax('@htmlCss', 'css')
endif

" Avoid overload
if hlexists('javaScriptComment') == 0
  call s:LoadSyntax('@htmlJavaScript', 'javascript')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load pre-processors syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If sass is enabled, load sass syntax 
if s:use_sass
  call s:LoadSyntax('@SassSyntax', 'sass')
endif

" If less is enabled, load less syntax 
if s:use_less
  call s:LoadSyntax('@LessSyntax', 'less')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax patch {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Patch 7.4.1142
if has("patch-7.4-1142")
  if has("win32")
    syn iskeyword @,48-57,_,128-167,224-235,$
  else
    syn iskeyword @,48-57,_,192-255,$
  endif
endif

" Clear htmlHead that may cause highlighting out of bounds
syntax clear htmlHead

" Redefine syn-region to color <style> correctly.
if s:use_less
  syntax region lessDefinition matchgroup=cssBraces contains=@LessSyntax contained
        \ start="{" end="}" 
endif
if s:use_sass
  syntax region sassDefinition matchgroup=cssBraces contains=@SassSyntax contained
        \ start="{" end="}" 
endif

" Number with minus
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' containedin=@javascriptSvelteScript

" html5 data-*
syntax match htmlArg '\v<data(-[.a-z0-9]+)+>' containedin=@HTMLSyntax
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All start with html/javascript/css for emmet-vim type detection
syntax region htmlSvelteTemplate fold
      \ start="<[-:a-zA-Z0-9]\+\(\s.\{-}\)\?>" 
      \ end="^</[-:a-zA-Z0-9]\+>" 
      \ keepend contains=@HTMLSyntax
" Tag in one line
syntax match htmlSvelteTemplate fold
      \ "<[-:a-zA-Z0-9]\+\(\s.\{-}\)\?>.*</[-:a-zA-Z0-9]\+>" 
      \ contains=@HTMLSyntax
" Empty tag in one line
syntax match htmlSvelteTemplate fold
      \ "<[-:a-zA-Z0-9]\+\(\s.\{-}\)\?\s*/>" 
      \ contains=@HTMLSyntax
" @html,@debug tag in one line
syntax match htmlSvelteTemplate fold
      \ "{@\(html\|debug\)\(\s.\{-}\)\?\s*}" 
      \ contains=@HTMLSyntax
" Control block
syntax region htmlSvelteTemplate fold
      \ start="{#[-a-zA-Z0-9]\+\(\s.\{-}\)\?}" 
      \ end="^{/[-a-zA-Z0-9]\+}" 
      \ keepend contains=@HTMLSyntax

syntax region javascriptSvelteScript fold
      \ start="<script\(\s.\{-}\)\?>" 
      \ end="</script>" 
      \ keepend 
      \ contains=@htmlJavaScript,jsImport,jsExport,svelteTag,svelteKeyword

syntax region cssSvelteStyle fold
      \ start="<style\(\s.\{-}\)\?>" 
      \ end="</style>" 
      \ keepend contains=@htmlCss,svelteTag
syntax region cssLessSvelteStyle fold
      \ start=+<style lang="less"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@LessSyntax,svelteTag
syntax region cssSassSvelteStyle fold
      \ start=+<style lang="sass"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,svelteTag
syntax region cssScssSvelteStyle fold
      \ start=+<style lang="scss"\(\s.\{-}\)\?>+ 
      \ end=+</style>+ 
      \ keepend contains=@SassSyntax,svelteTag

syntax region svelteTag 
      \ start="<[^/]" end=">" 
      \ contained contains=htmlTagN,htmlString,htmlArg fold
syntax region svelteTag 
      \ start="</" end=">" 
      \ contained contains=htmlTagN,htmlString,htmlArg
syntax keyword svelteKeyword $ contained

highlight def link svelteTag htmlTag
highlight def link svelteKeyword Keyword
"}}}

let b:current_syntax = 'svelte'
" vim: fdm=marker
