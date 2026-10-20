" Svelte template syntax
let g:test_flatten = 1
packadd matchit

function! Check()
  call ExpectSyntax('svelte:head', 'svelteComponentName')
  call ExpectSyntax('{#if', 'svelteBlockStart')
  call ExpectSyntax('on:click', 'svelteKey')
  call ExpectSyntax('count > 1', 'svelteExpression')
  call ExpectSyntax('{:else if', 'svelteBlockBody')
  call ExpectSyntax('|once', 'svelteKey')
  call ExpectSyntax('{/if}', 'svelteBlockEnd')
  call ExpectSyntax('{#each', 'svelteBlockStart')
  call ExpectSyntax('as item', 'svelteBlockKeyword')
  call ExpectSyntax('data-id', 'htmlArg')
  call ExpectSyntax('{item.name}', 'svelteExpression')
  call ExpectSyntax('{#await', 'svelteBlockStart')
  call ExpectSyntax('{:then', 'svelteBlockBody')
  call ExpectSyntax('{:catch', 'svelteBlockBody')
  call ExpectSyntax('{#key', 'svelteBlockStart')
  call ExpectSyntax('Nested', 'svelteComponentName')
  call ExpectSyntax('bind:checked', 'svelteKey')
  call ExpectSyntax('UI.Button', 'svelteComponentName')
  call ExpectSyntax('@html', 'svelteAtTags')
  call ExpectSyntax('@debug', 'svelteAtTags')

  " Jump between block parts with % by matchit
  normal! gg
  call search('{#if')
  let lines = []
  for i in range(4)
    call add(lines, line('.'))
    normal %
  endfor
  call ExpectEqual(lines, [15, 17, 19, 21], 'lines after % from {#if}')
endfunction
