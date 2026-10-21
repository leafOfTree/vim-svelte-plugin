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

" For advanced users, this variable can be used to avoid overload
let b:current_loading_main_syntax = 'svelte'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:config = svelte#GetSvelteConfig()
let s:config_syntax = s:config.syntax
let s:full_syntax = s:config.full_syntax
let s:syntax_list = svelte#GetSyntaxList(s:config_syntax)
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax groups. Keep the names of html.vim and vim-coffee-script/after/html.vim
let s:groups = {
      \ 'html': '@HTMLSyntax',
      \ 'css': '@htmlCss',
      \ 'javascript': '@htmlJavaScript',
      \ 'coffee': '@htmlCoffeeScript',
      \ 'typescript': '@TypeScript',
      \ 'pug': '@PugSyntax',
      \ 'less': '@LessSyntax',
      \ 'sass': '@SassSyntax',
      \ 'scss': '@SassSyntax',
      \ 'stylus': '@StylusSyntax',
      \ }

" Syntax files to load, scss is in sass.vim
let s:syntax_files = {'scss': 'sass'}

function! s:GetGroup(syntax)
  return get(s:groups, a:syntax, '@'.a:syntax.'Syntax')
endfunction

function! s:LoadSyntax(group, type)
  if index(s:full_syntax, a:type) != -1
    call s:LoadFullSyntax(a:group, a:type)
    return 1
  elseif !s:LoadDefaultSyntax(a:group, a:type)
    " Not in Vim, maybe from plugins
    call s:LoadFullSyntax(a:group, a:type)
    return 1
  endif
  return 0
endfunction

" Load syntax only in $VIMRUNTIME/syntax, $VIM/vimfiles/syntax and
" ~/.vim/syntax. Return whether any is found
function! s:LoadDefaultSyntax(group, type)
  unlet! b:current_syntax
  let loaded = 0
  let syntaxPaths = ['$VIMRUNTIME', '$VIM/vimfiles', '$HOME/.vim']
  for path in syntaxPaths
    let file = expand(path).'/syntax/'.a:type.'.vim'
    if filereadable(file)
      execute 'syntax include '.a:group.' '.file
      let loaded = 1
    endif
  endfor
  return loaded
endfunction

" Load syntax in 'runtimepath', including plugins
function! s:LoadFullSyntax(group, type)
  if empty(globpath(&runtimepath, 'syntax/'.a:type.'.vim'))
    return
  endif
  call s:SetCurrentSyntax(a:type)
  exec 'syntax include '.a:group.' syntax/'.a:type.'.vim'
endfunction

" Settings to avoid syntax overload
function! s:SetCurrentSyntax(type)
  if a:type == 'coffee'
    syntax cluster coffeeJS contains=@htmlJavaScript

    " Avoid overload of `javascript.vim`
    let b:current_syntax = 'svelte'
  else
    unlet! b:current_syntax
  endif
endfunction
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load main syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load syntax/html.vim to syntax group, which loads full JavaScript and CSS
" syntax. It defines group htmlJavaScript and htmlCss.
call s:LoadSyntax('@HTMLSyntax', 'html')

" Avoid overload
if !hlexists('cssTagName')
  call s:LoadSyntax('@htmlCss', 'css')
endif

" Avoid overload
if !hlexists('javaScriptComment')
  call s:LoadSyntax('@htmlJavaScript', 'javascript')
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load syntax in config like pre-processors {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:loaded_files = []
for s:syntax in s:syntax_list
  let s:file = get(s:syntax_files, s:syntax, s:syntax)
  if index(['html', 'css', 'javascript'], s:syntax) != -1
        \ || index(s:loaded_files, s:file) != -1
    continue
  endif
  call add(s:loaded_files, s:file)
  if !s:LoadSyntax(s:GetGroup(s:syntax), s:file)
    execute 'runtime! after/syntax/'.s:file.'.vim'
  endif
endfor
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Load Svelte specific html syntax {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax include syntax/svelte-html.vim
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax highlight {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All start with html/javascript/css for emmet-vim in-file type detection
" Tag name and attributes. '>' may be in expressions like {() => a > b}
let s:tag_start = '<[-:a-zA-Z0-9]\+\%([^>{]\|{[^}]*}\)*'

" Normal tag template
execute 'syntax region htmlSvelteTemplate fold'
      \ 'start=+'.s:tag_start.'>$+'
      \ 'end=+^</[-:a-zA-Z0-9]\+>+'
      \ 'keepend contains=@HTMLSyntax'
" Start tag across multiple lines or Empty tag across multiple lines, which
" may end in an expression
execute 'syntax region htmlSvelteTemplate fold'
      \ 'start=+'.s:tag_start.'\%({[^}]*\)\?$+'
      \ 'end=+^\(<\/[-:a-zA-Z0-9]\+>\|\(\S[^<]*\)\?\/>\)+'
      \ 'keepend contains=@HTMLSyntax'

" Tag in one line
execute 'syntax match htmlSvelteTemplate fold'
      \ '+'.s:tag_start.'>.*</[-:a-zA-Z0-9]\+>+'
      \ 'contains=@HTMLSyntax'
" Empty tag in one line
execute 'syntax match htmlSvelteTemplate fold'
      \ '+'.s:tag_start.'/>+'
      \ 'contains=@HTMLSyntax'
" @html, @debug, @render tag in one line
syntax match htmlSvelteTemplate fold
      \ +{@\(html\|debug\|render\)[^}]*}+ 
      \ contains=@HTMLSyntax
" Control blocks like {#if ...}, {#each ...}
syntax region htmlSvelteTemplate fold
      \ start=+{#[-a-zA-Z0-9]\+[^}]*}+ 
      \ end=+^{/[-a-zA-Z0-9]\+}+ 
      \ keepend contains=@HTMLSyntax

" Blocks <script>, <style> and <template lang="..."> by config. Name like
" javascriptSvelteScript and cssScssSvelteStyle with css prefix for emmet-vim
function! s:GetName(syntax, tag)
  let Upper = {str -> toupper(str[0]).str[1:]}
  if a:tag ==# 'style' && a:syntax !=# 'css'
    return 'css'.Upper(a:syntax).'SvelteStyle'
  endif
  return a:syntax.'Svelte'.Upper(a:tag)
endfunction

function! s:GetContains(syntax)
  let contains = s:GetGroup(a:syntax).',svelteTag'
  if a:syntax ==# 'javascript'
    let contains .= ',jsImport,jsExport,svelteKeyword'
  elseif a:syntax ==# 'coffee'
    let contains .= ',jsImport,jsExport'
  endif
  return contains
endfunction

" Values of lang attribute for syntax. SugarSS (lang="sss") is indent-based
" like sass
let s:lang_names = {'typescript': '\(ts\|typescript\)', 'sass': '\(sass\|sss\)'}

" lang="..." in double or single quotes or without quotes
function! s:Lang(syntax)
  return 'lang=["'']\?'.get(s:lang_names, a:syntax, a:syntax).'\>["'']\?'
endfunction

function! s:SetBlock(name, tag, lang, contains)
  execute 'syntax region '.a:name.' fold'
        \ 'start=+<'.a:tag.'[^>]*'.a:lang.'[^>]*>+'
        \ 'end=+</'.a:tag.'>+'
        \ 'keepend contains='.a:contains
endfunction

" Without lang, the first syntax in config
for s:tag in ['script', 'style']
  let s:syntax = get(s:config_syntax[s:tag], 0,
        \ s:tag ==# 'script' ? 'javascript' : 'css')
  call s:SetBlock(s:GetName(s:syntax, s:tag), s:tag, '',
        \ s:GetContains(s:syntax))
endfor

for s:tag in ['template', 'script', 'style']
  for s:syntax in get(s:config_syntax, s:tag, [])
    if s:tag ==# 'template' && s:syntax ==# 'html'
      continue
    endif
    call s:SetBlock(s:GetName(s:syntax, s:tag), s:tag, s:Lang(s:syntax),
          \ s:GetContains(s:syntax))
  endfor
endfor

" Languages supported before g:vim_svelte_plugin_config. If not in config,
" TypeScript is highlighted as the first syntax of script, others in
" lang="..." have their block without syntax as before
if !svelte#Has(s:config_syntax.script, 'typescript')
  let s:syntax = get(s:config_syntax.script, 0, 'javascript')
  call s:SetBlock('typescriptSvelteScript', 'script', s:Lang('typescript'),
        \ s:GetContains(s:syntax))
endif
for [s:tag, s:syntax] in [['template', 'pug'], ['script', 'coffee'],
      \ ['style', 'less'], ['style', 'sass'], ['style', 'scss'],
      \ ['style', 'stylus']]
  if !svelte#Has(s:syntax_list, s:syntax)
    call s:SetBlock(s:GetName(s:syntax, s:tag), s:tag,
          \ 'lang="'.get(s:lang_names, s:syntax, s:syntax).'"',
          \ s:GetContains(s:syntax))
  endif
endfor

syntax region svelteTag 
      \ start=+^<[^/]+ end=+>+  skip=+></+
      \ contained contains=htmlTagN,htmlString,htmlArg fold
syntax region svelteTag 
      \ start=+^</+ end=+>+ 
      \ contained contains=htmlTagN,htmlString,htmlArg
syntax keyword svelteKeyword $ contained

highlight default link svelteTag htmlTag
highlight default link svelteKeyword Keyword
highlight default link cssUnitDecorators2 Number
highlight default link cssKeyFrameProp2 Constant
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntax patch {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add '$' to keyword characters for svelteKeyword, keeping others like '-'
" from css.vim for css keywords such as font-size
if has('patch-7.4.1142') && exists('*execute')
  let s:iskeyword = matchstr(execute('syntax iskeyword'),
        \ 'syntax iskeyword \zs\S\+')
  if empty(s:iskeyword) || s:iskeyword ==# 'not'
    let s:iskeyword = &iskeyword
  endif
  execute 'syntax iskeyword '.s:iskeyword.',$'
endif

" Style
" Redefine (less|sass)Definition to highlight <style> correctly and 
" enable emmet-vim css type.
if svelte#Has(s:syntax_list, 'less')
  silent! syntax clear lessDefinition
  syntax region cssLessDefinition matchgroup=cssBraces 
        \ contains=@LessSyntax,cssLessDefinition
        \ contained containedin=cssLessSvelteStyle
        \ start="{" end="}" 
endif

if svelte#Has(s:syntax_list, 'sass') || svelte#Has(s:syntax_list, 'scss')
  silent! syntax clear sassDefinition
  syntax region cssSassDefinition matchgroup=cssBraces 
        \ contains=@SassSyntax,cssSassDefinition
        \ contained containedin=cssScssSvelteStyle,cssSassSvelteStyle
        \ start="{" end="}" 
endif

if svelte#Has(s:syntax_list, 'stylus')
  silent! syntax clear stylusDefinition
  syntax region cssStylusDefinition matchgroup=cssBraces 
        \ contains=@StylusSyntax,cssStylusDefinition
        \ contained containedin=cssStylusSvelteStyle
        \ start="{" end="}" 
endif

" Avoid css syntax interference
silent! syntax clear cssUnitDecorators
" Have to use a different name
syntax match cssUnitDecorators2 
      \ /\(#\|-\|+\|%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|ch\|rem\|vh\|vw\|vmin\|vmax\|dpi\|dppx\|dpcm\|Hz\|kHz\|s\|ms\|deg\|grad\|rad\)\ze\(;\|$\)/
      \ contained
      \ containedin=cssAttrRegion,sassCssAttribute,lessCssAttribute

silent! syntax clear cssKeyFrameProp
syn match cssKeyFrameProp2 /\d*%\|from\|to/ 
      \ contained nextgroup=cssDefinition
      \ containedin=cssAttrRegion,sassCssAttribute,lessCssAttribute

" HTML
" Clear htmlHead that may cause highlighting out of bounds
silent! syntax clear htmlHead

" JavaScript
" Number with minus
syntax match javaScriptNumber '\v<-?\d+L?>|0[xX][0-9a-fA-F]+>' 
      \ containedin=@javascriptSvelteScript display

" TypeScript
" Fix template string `...` breaking syntax highlighting
syntax region  typescriptTemplate
  \ start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/
  \ contains=typescriptTemplateSubstitution,typescriptSpecial,@Spell
  \ containedin=typescriptObjectLiteral
  \ nextgroup=@typescriptSymbols
  \ skipwhite skipempty

" html5 data-*
syntax match htmlArg '\v<data(-[.a-z0-9]+)+>' containedin=@HTMLSyntax
"}}}

syntax sync fromstart
let b:current_syntax = 'svelte'
" vim: fdm=marker
