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
let s:template_tag = '\v^\s*\<\/?template'
" https://developer.mozilla.org/en-US/docs/Glossary/Empty_element
let s:empty_tagname = '(area|base|br|col|embed|hr|input|img|keygen|link|meta|param|source|track|wbr)'
" Empty tag ending with '>' but not '/>'. '>' in {...} like {(e) => f(e)} or
" in quotes doesn't end the tag
let s:empty_tag = '\v\C\<'.s:empty_tagname
      \ .'>(\{[^}]*\}|"[^"]*"|''[^'']*''|[^\>{"''/]|/(\>)@!)*\>'
let s:empty_tag_start = '\v\<'.s:empty_tagname.'[^\>]*$' 
let s:empty_tag_end = '\v^\s*[^\<\>\/]*\>\s*' 
let s:tag_start = '^<$'
let s:tag_end = '\v^\s*\/?\>\s*'
let s:multiline_tag_start = '\v^\s*\<[-:.a-zA-Z0-9]+[^>]*$'
let s:oneline_block = '^\s*{#.*{/.*}\s*$'
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:config = svelte#GetSvelteConfig()
let s:initial_indent = s:config.initial_indent
let s:debug = s:config.debug
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load indent method {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save shiftwidth
let s:sw = &sw

" Use specific indent files for compatibility
unlet! b:did_indent
runtime indent/svelte-xml.vim

unlet! b:did_indent
runtime indent/svelte-css.vim

" Use normal indent files
unlet! b:did_indent
runtime! indent/javascript.vim
let b:javascript_indentexpr = &indentexpr

" Indent files of syntax in config. Syntax with an empty value, like pug
" not in config, keeps indent as its indent file isn't loaded. css, less,
" scss use GetCSSIndent()
let s:indent = {'pug': '', 'coffee': '', 'sass': '', 'stylus': ''}
let s:save_formatoptions = &formatoptions
for s:syntax in svelte#GetSyntaxList(s:config.syntax)
  if index(['html', 'css', 'javascript', 'less', 'scss'], s:syntax) != -1
    continue
  endif
  unlet! b:did_indent
  let &l:indentexpr = ''
  execute 'runtime! indent/'.s:syntax.'.vim'
  let s:indent[s:syntax] = &l:indentexpr
endfor
let &formatoptions = s:save_formatoptions

" Recover shiftwidth
let &sw = s:sw
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Settings {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JavaScript indentkeys
setlocal indentkeys=0{,0},0),0],0\,,!^F,o,O,e,:,=:else
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

  let curline = getline(v:lnum)
  let cursyns = s:SynsSOL(v:lnum)
  let cursyn = get(cursyns, 0, '')
  let [tag, syntax] = s:BlockTagAndSyntax(cursyn)
  let keep = 0

  if s:IsMultipleLineTemplateString(curline, cursyns)
    call s:Log('current line is multiline template string expression')
    if !s:IsMultipleLineTemplateString(prevline, prevsyns)
      let ind = indent(v:lnum - 1) + shiftwidth()
    else
      let ind = indent(v:lnum - 1)
    endif
  elseif s:SynHTML(cursyn) && !s:IsMultipleLineSvelteExpression(curline, cursyns)
    call s:Log('syntax: html')
    let ind = XmlIndentGet(v:lnum, 0)
    if prevline =~? s:empty_tag
      call s:Log('previous line is empty tag')
      let ind = ind - shiftwidth()
    endif

    if s:IsBlockStart(prevsyns) && prevline !~ s:oneline_block
      call s:Log('increase block indent')
      let ind = ind + shiftwidth()
    endif

    if s:IsBlockEnd(cursyns, curline)
      call s:Log('decrease block indent')
      let ind = ind - shiftwidth()
    endif

    " Align '/>' and '>' with '<' for multiline tags.
    if curline =~? s:tag_end 
      let ind = ind - shiftwidth()
    endif
    " Then correct the indentation of any element following '/>' or '>'.
    if prevline =~? s:tag_end
      let ind = ind + shiftwidth()

      "Decrease indent if prevlines are a multiline empty tag
      let [start, end] = s:PrevMultilineEmptyTag(v:lnum)
      if end == prevlnum
        call s:Log('previous line is a multiline empty tag')
        let ind = indent(v:lnum - 1)
      endif
    endif
  elseif has_key(s:indent, syntax)
    call s:Log('syntax: '.syntax)
    if empty(s:indent[syntax])
      call s:Log('no indent for '.syntax.', keep indent')
      let keep = 1
      let ind = indent(v:lnum)
    else
      let ind = eval(s:indent[syntax])
    endif
  elseif tag ==# 'style'
    call s:Log('syntax: style')
    let ind = GetCSSIndent()
  elseif s:IsTagStart(curline)
    call s:Log('syntax: tagstart')
    let ind = 0
  else
    call s:Log('syntax: javascript')
    if len(b:javascript_indentexpr)
      let ind = eval(b:javascript_indentexpr)
    else
      let ind = cindent(v:lnum)
    endif
  endif

  if curline =~? s:svelte_tag_start || curline =~? s:svelte_tag_end 
        \|| prevline =~? s:svelte_tag_end
        \|| (curline =~ s:template_tag && s:SynPug(cursyn))
    call s:Log('current line is svelte tag or previous line is svelte tag end')
    call s:Log('... or current line is pug template tag')
    let ind = 0
  elseif keep
    return ind
  elseif s:HasInitialIndent(tag, syntax)
    if ind == 0
      call s:Log('add initial indent')
      let ind = shiftwidth()
    endif
  elseif prevline =~? s:svelte_tag_start
    call s:Log('previous line is svelte tag start')
    let ind = 0
  endif

  call s:Log('indent: '.ind)
  return ind
endfunction

function! s:IsTagStart(curline)
  return a:curline =~ s:tag_start
endfunction

function! s:IsBlockStart(prevsyns)
  let prevsyn_second = get(a:prevsyns, 1, '')
  " Some HTML tags add an extra syntax layer
  let prevsyn_third = get(a:prevsyns, 2, '')
  return s:SynBlockBody(prevsyn_second)
        \ || s:SynBlockStart(prevsyn_second)
        \ || s:SynBlockBody(prevsyn_third)
        \ || s:SynBlockStart(prevsyn_third)
endfunction

function! s:IsBlockEnd(cursyns, curline)
  let cursyn_second = get(a:cursyns, 1, '')
  " Some HTML tags add an extra syntax layer
  let cursyn_third = get(a:cursyns, 2, '')
  return a:curline !~ '^\s*$'
        \ && (s:SynBlockBody(cursyn_second)
        \ || s:SynBlockEnd(cursyn_second)
        \ || s:SynBlockBody(cursyn_third)
        \ || s:SynBlockEnd(cursyn_third))
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

function! s:IsMultipleLineSvelteExpression(curline, syns)
  if a:curline =~ '^\s*{.*}\s*$'
    return 0
  endif

  for syn in a:syns
    if syn ==? 'svelteExpression'
      return 1
    endif
  endfor

  return 0
endfunction

function! s:IsMultipleLineTemplateString(curline, syns)
  if a:curline =~ '^\s*{.*}\s*$'
    return 0
  endif

  for syn in a:syns
    if syn ==? 'javaScriptTemplateString'
      return 1
    endif
  endfor

  return 0
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

function! s:SynPug(syn)
  return a:syn ==? 'pugSvelteTemplate'
endfunction

" Block tag and syntax by syntax name like javascriptSvelteScript and
" cssScssSvelteStyle, or ['', ''] if not in a block
function! s:BlockTagAndSyntax(syn)
  let parts = matchlist(a:syn, '\v^(\w{-})Svelte(Script|Style|Template)$')
  if empty(parts)
    return ['', '']
  endif
  let syntax = parts[1]
  if syntax =~# '^css\u'
    let syntax = tolower(syntax[3]).syntax[4:]
  endif
  return [tolower(parts[2]), syntax]
endfunction

" By tag, syntax or tag.syntax in initial_indent
function! s:HasInitialIndent(tag, syntax)
  return !empty(a:tag) && (svelte#Has(s:initial_indent, a:tag)
        \ || svelte#Has(s:initial_indent, a:syntax)
        \ || svelte#Has(s:initial_indent, a:tag.'.'.a:syntax))
endfunction

function! s:PrevMultilineEmptyTag(lnum)
  let lnum = a:lnum - 1
  let lnums = [0, 0]
  while lnum > 0
    let line = getline(lnum)
    if line =~? s:empty_tag_end
      let lnums[1] = lnum
    endif

    if line =~? s:multiline_tag_start
      if line =~? s:empty_tag_start
        let lnums[0] = lnum
        return lnums
      else
        return [0, 0]
      endif
    endif

    let lnum = lnum - 1
  endwhile
  return [0, 0]
endfunction

function! s:Log(msg)
  if s:debug
    echom '['.s:name.']['.v:lnum.'] '.a:msg
  endif
endfunction
"}}}

let b:did_indent = 1
" vim: fdm=marker
