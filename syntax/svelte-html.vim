"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:highlight_svelte_attr = exists("g:vim_svelte_plugin_highlight_svelte_attr")
      \ && g:vim_svelte_plugin_highlight_svelte_attr == 1
")}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax match svelteComponentName 
      \ '\v\C<[A-Z][a-zA-Z0-9]+(\.[A-Z][a-zA-Z0-9]+)*>'
      \ containedin=htmlTagN 

syntax match svelteAttr 
      \ '\v(\S)@<!(on|bind|use):[^\=\>[:blank:]]+(\=\"[^"]*\"|\=\{[^}]*\})?'
      \ containedin=htmlTag 
      \ contains=svelteKey,svelteValue

syntax match svelteKey contained '\v(on|bind|use):[^\=\>[:blank:]]+'
" syntax match svelteValue contained '\v\=\"[^"]*\"'
syntax match svelteValue contained '\v\{[^}]*\}'

syntax region svelteExpression 
      \ containedin=htmlH.*,htmlItalic
      \ matchgroup=svelteBrace
      \ transparent
      \ start="{"
      \ end="}"

syntax region svelteExpression 
      \ containedin=htmlSvelteTemplate,svelteValue,htmlString,htmlValue,htmlArg,htmlTag
      \ contains=@simpleJavascriptExpression
      \ matchgroup=svelteBrace
      \ transparent
      \ start="{"
      \ end="}\(}\)\@!"

syntax region svelteBlockBody
      \ containedin=htmlSvelteTemplate
      \ contains=@simpleJavascriptExpression,svelteBlockKeyword
      \ matchgroup=svelteBrace
      \ start="\v\{:"
      \ end="}"

syntax region svelteBlockStart
      \ containedin=htmlSvelteTemplate
      \ contains=@simpleJavascriptExpression,svelteBlockKeyword
      \ matchgroup=svelteBrace
      \ start="\v\{#"
      \ end="}"

syntax region svelteBlockEnd
      \ containedin=htmlSvelteTemplate
      \ contains=@simpleJavascriptExpression,svelteBlockKeyword
      \ matchgroup=svelteBrace
      \ start="\v\{\/"
      \ end="}"

syntax keyword svelteBlockKeyword if else each await then catch as

syntax cluster simpleJavascriptExpression contains=javaScriptStringS,javaScriptStringD,javascriptNumber,javaScriptOperator

" JavaScript syntax
syntax region  javaScriptStringS	
      \ start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contained
syntax region  javaScriptStringD	
      \ start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contained
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' contained
syntax match javaScriptOperator '[-!|&+<>=%*~^]' contained
syntax match javaScriptOperator '\v(*)@<!/(/|*)@!' contained
syntax keyword javaScriptOperator delete instanceof typeof void new in of contained

highlight default link svelteAttr htmlTag
if s:highlight_svelte_attr
  highlight default link svelteKey Type
  highlight default link svelteValue None
else
  highlight default link svelteKey htmlArg
  highlight default link svelteValue String
endif

highlight default link svelteBrace Type
highlight default link svelteBlockKeyword Statement
highlight default link svelteComponentName htmlTagName
highlight default link javaScriptStringS String
highlight default link javaScriptStringD String
highlight default link javaScriptNumber	Constant
highlight default link javaScriptOperator	Operator
"}}}
" vim: fdm=marker
