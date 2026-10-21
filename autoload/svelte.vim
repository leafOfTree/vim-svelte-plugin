function! svelte#GetConfig(name, default)
  let name = 'g:vim_svelte_plugin_'.a:name
  return exists(name) ? eval(name) : a:default
endfunction

" Config from g:vim_svelte_plugin_config, on top of the default derived from
" previous g:vim_svelte_plugin_* variables, which still work. Keys of
" 'syntax' in g:vim_svelte_plugin_config replace the ones in the default
" separately, others replace the whole value.
function! svelte#GetSvelteConfig()
  let config = s:GetDefaultConfig()
  let user = svelte#GetConfig('config', {})
  for [key, value] in items(user)
    if key ==# 'syntax' && type(value) == v:t_dict
      call extend(config.syntax, value)
    else
      let config[key] = value
    endif
  endfor
  for [tag, value] in items(config.syntax)
    let config.syntax[tag] = s:ToList(value)
  endfor
  let config.full_syntax = s:ToList(config.full_syntax)
  let config.initial_indent = s:ToList(config.initial_indent)
  return config
endfunction

function! s:GetDefaultConfig()
  let Get = function('svelte#GetConfig')
  let script = ['javascript']
        \ + (Get('use_typescript', 0) ? ['typescript'] : [])
        \ + (Get('use_coffee', 0) ? ['coffee'] : [])
  let style = ['css']
        \ + (Get('use_less', 0) ? ['less'] : [])
        \ + (Get('use_sass', 0) ? ['scss', 'sass'] : [])
        \ + (Get('use_stylus', 0) ? ['stylus'] : [])
  let template = Get('use_pug', 0) ? ['pug'] : []
  let full_syntax = ['pug', 'coffee', 'typescript']
  if Get('load_full_syntax', 0)
    let full_syntax += ['html', 'css', 'javascript', 'less', 'sass', 'stylus']
  endif
  return {
        \ 'syntax': {'script': script, 'style': style, 'template': template},
        \ 'full_syntax': full_syntax,
        \ 'initial_indent': Get('has_init_indent', 1) ? ['script', 'style'] : [],
        \ 'attribute': Get('highlight_svelte_attr', 0),
        \ 'foldexpr': Get('use_foldexpr', 0),
        \ 'open_devdocs': Get('open_devdocs', '<F1>'),
        \ 'debug': Get('debug', 0),
        \ }
endfunction

function! s:ToList(value)
  return type(a:value) == v:t_list ? copy(a:value) : [a:value]
endfunction

function! svelte#Has(list, item)
  return index(a:list, a:item) != -1
endfunction

" Syntax in all blocks, without duplicates, in config order
function! svelte#GetSyntaxList(config_syntax)
  let syntax_list = []
  for tag in ['template', 'script', 'style']
    for syntax in get(a:config_syntax, tag, [])
      if index(syntax_list, syntax) == -1
        call add(syntax_list, syntax)
      endif
    endfor
  endfor
  return syntax_list
endfunction

" Since svelte#Log and svelte#GetConfig are always called 
" in syntax and indent files,
" this file will be sourced when opening the first svelte file
if exists('##CursorMoved') && exists('*OnChangeSvelteSubtype')
  augroup vim_svelte_plugin
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinEnter *.svelte
          \ call s:CheckSubtype()
  augroup END

  let s:subtype = ''
  function! s:CheckSubtype()
    let subtype = GetSvelteSubtype()

    if s:subtype != subtype
      call OnChangeSvelteSubtype(subtype)
      let s:subtype = subtype
    endif
  endfunction
endif

function! s:SynsEOL(lnum)
  let lnum = prevnonblank(a:lnum)
  let cnum = strlen(getline(lnum))
  return map(synstack(lnum, cnum), 'synIDattr(v:val, "name")')
endfunction

function! GetSvelteSubtype()
  let lnum = line('.')
  let cursyns = s:SynsEOL(lnum)
  let syn = !empty(cursyns) ? get(cursyns, 0, '') : ''

  let subtype = matchstr(syn, '\w\+\zeSvelte')
  if subtype =~ 'css\w\+'
    " For cssScss, cssLess, ...
    let subtype = subtype[3:]
  endif
  let subtype = tolower(subtype)
  return subtype
endfunction

function! GetSvelteTag(...)
  let lnum = a:0 > 0 ? a:1 : line('.')
  let cursyns = s:SynsEOL(lnum)
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
