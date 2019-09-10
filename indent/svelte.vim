"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim indent file
"
" Language: Svelte
" Maintainer: leafOfTree <leafvocation@gmail.com>
"
" CREDITS: Inspired by mxw/vim-jsx.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:did_indent")
  finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Variables {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:name = 'vim-svelte-plugin'
" Let <template> handled by HTML
let s:svelte_tag_start = '\v^\<(script|style)' 
let s:svelte_tag_end = '\v^\<\/(script|style)'
let s:empty_tagname = '(area|base|br|col|embed|hr|input|img|keygen|link|meta|param|source|track|wbr)'
let s:empty_tag = '\v\<'.s:empty_tagname.'[^/]*\>' 
let s:empty_tag_start = '\v\<'.s:empty_tagname.'[^\>]*$' 
let s:empty_tag_end = '\v^\s*[^\<\>\/]*\>\s*' 
let s:tag_end = '\v^\s*\/?\>\s*'
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:use_sass = exists("g:vim_svelte_plugin_use_sass")
      \ && g:vim_svelte_plugin_use_sass == 1
let s:has_init_indent = !exists("g:vim_svelte_plugin_has_init_indent") 
      \ || g:vim_svelte_plugin_has_init_indent == 1
let s:debug = exists("g:vim_svelte_plugin_debug")
      \ && g:vim_svelte_plugin_debug == 1
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load indent method {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use lib/indent/ files for compatibility
unlet! b:did_indent
runtime lib/indent/xml.vim

unlet! b:did_indent
runtime lib/indent/css.vim

" Use normal indent files
unlet! b:did_indent
runtime! indent/javascript.vim
let b:javascript_indentexpr = &indentexpr

if s:use_sass
  unlet! b:did_indent
  runtime! indent/sass.vim
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Settings {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
setlocal sw=2 ts=2
" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e
" XML indentkeys
setlocal indentkeys+=*<Return>,<>>,<<>,/
setlocal indentexpr=GetSvelteIndent()
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetSvelteIndent()
  let prevlnum = prevnonblank(v:lnum-1)
  let prevline = getline(prevlnum)
  let prevsyns = s:SynsSOL(prevlnum)
  let prevsyn = get(prevsyns, 0, '')
  let prevsyn_second = get(prevsyns, 1, '')

  let curline = getline(v:lnum)
  let cursyns = s:SynsSOL(v:lnum)
  let cursyn = get(cursyns, 0, '')
  let cursyn_second = get(cursyns, 1, '')

  if s:SynHTML(cursyn)
    call s:Log('syntax: html')
    let ind = XmlIndentGet(v:lnum, 0)
    if prevline =~? s:empty_tag
      call s:Log('prev line is empty tag')
      let ind = ind - &sw
    endif

    if s:SynBlockBody(prevsyn_second) || s:SynBlockStart(prevsyn_second)
      call s:Log('increase block indent')
      let ind = ind + &sw
    endif

    if curline !~ '^\s*$' && (s:SynBlockBody(cursyn_second) || s:SynBlockEnd(cursyn_second))
      call s:Log('decrease block indent')
      let ind = ind - &sw
    endif

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:tag_end 
      let ind = ind - &sw
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:tag_end
      let ind = ind + &sw

      "Decrease indent if prevlines are a multiline empty tag
      let [start, end] = s:PrevMultilineEmptyTag(v:lnum)
      if end == prevlnum
        call s:Log('prev line is a multiline empty tag')
        let ind = ind - &sw
      endif
    endif
  elseif s:SynSASS(prevsyn)
    call s:Log('syntax: sass')
    let ind = GetSassIndent()
  elseif s:SynStyle(prevsyn)
    call s:Log('syntax: style')
    let ind = GetCSSIndent()
  else
    call s:Log('syntax: javascript')
    if len(b:javascript_indentexpr)
      let ind = eval(b:javascript_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:svelte_tag_start || curline =~? s:svelte_tag_end 
        \ || prevline =~? s:svelte_tag_end
    call s:Log('current line is svelte tag or prev line is svelte end tag')
    let ind = 0
  elseif s:has_init_indent
    call s:Log('has init indent')
    if s:SynSvelteScriptOrStyle(cursyn) && ind == 0
      call s:Log('add initial indent')
      let ind = &sw
    endif
  elseif prevline =~? s:svelte_tag_start
    call s:Log('prev line is svelte tag')
    let ind = 0
  endif

  call s:Log('indent: '.ind)
  return ind
endfunction

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = strlen(getline(lnum))
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynsSOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let col = match(getline(lnum), '\S') + 1
  return map(synstack(lnum, col), 'synIDattr(v:val, "name")')
endfunction

function! s:SynHTML(syn)
  return a:syn ==? 'htmlSvelteTemplate'
endfunction

function! s:SynBlockBody(syn)
  return a:syn ==? 'svelteBlockBody'
endfunction

function! s:SynBlockStart(syn)
  return a:syn ==? 'svelteBlockStart'
endfunction

function! s:SynBlockEnd(syn)
  return a:syn ==? 'svelteBlockEnd'
endfunction

function! s:SynSASS(syn)
  return a:syn ==? 'cssSassSvelteStyle'
endfunction

function! s:SynStyle(syn)
  return a:syn =~? 'SvelteStyle'
endfunction

function! s:SynSvelteScriptOrStyle(syn)
  return a:syn =~? '\v(SvelteStyle)|(SvelteScript)'
endfunction

function! s:PrevMultilineEmptyTag(lnum)
  let lnum = a:lnum
  let lnums = [0, 0]
  while lnum > 0
    let line = getline(lnum)
    if line =~? s:empty_tag_end
      let lnums[1] = lnum
    endif
    if line =~? s:empty_tag_start
      let lnums[0] = lnum
      return lnums
    endif
    let lnum = lnum - 1
  endwhile
endfunction

function! s:Log(msg)
  if s:debug
    echom '['.s:name.']['.v:lnum.'] '.a:msg
  endif
endfunction

function! GetSvelteTag()
  let lnum = getcurpos()[1]
  let cursyns = s:SynsSOL(lnum)
  let first_syn = get(cursyns, 0, '')

  if first_syn =~ '.*SvelteTemplate'
    let tag = 'template'
  elseif first_syn =~ '.*SvelteScript'
    let tag = 'script'
  elseif first_syn =~ '.*SvelteStyle'
    let tag = 'style'
  else
    let tag = ''
  endif

  return tag
endfunction
"}}}

let b:did_indent = 1
" vim: fdm=marker
