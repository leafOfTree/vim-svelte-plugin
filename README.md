# vim-svelte-plugin

Vim syntax and indent plugin for `.svelte` files. Forked from [vim-vue-plugin][3].

## Install

You can use your favourite plugin manager. For example, 

- Use [VundleVim][2]

        Plugin 'leafOfTree/vim-svelte-plugin'

- Use [vim-pathogen][5]

        cd ~/.vim/bundle && \
        git clone https://github.com/leafOfTree/vim-svelte-plugin --depth 1

- Use [vim-plug][7]

        Plug 'leafOfTree/vim-svelte-plugin'
        :PlugInstall

- Or manually, clone this plugin, drop it in custom `path/to/this_plugin`, and add it to `rtp` in vimrc

        set rpt+=path/to/this_plugin

The plugin works if `filetype` is set to `svelte`. Please stay up to date. Feel free to open an issue or a pull request.

## How it works

`vim-svelte-plugin` combines HTML, CSS and JavaScript syntax and indent in one file.

Supports

- Svelte directives.
- Less/Sass/Scss (see Configuration.).
- [emmet-vim][10] HTML/CSS/JavaScript filetype detection.
- A builtin foldexpr fold method.

## Configuration

Set global variable to `1` to enable or `0` to disable.

Ex:

    let g:vim_svelte_plugin_load_full_syntax = 1

| variable                              | description                                                                                            | default                    |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `g:vim_svelte_plugin_load_full_syntax`\* | Enable: load all syntax files in `runtimepath` to enable related syntax plugins.<br> Disable: only in `$VIMRUNTIME/syntax`, `~/.vim/syntax` and `$VIM/vimfiles/syntax` | 0 |
| `g:vim_vue_plugin_use_less`              | Enable less syntax for `<style lang="less">`.                                                          | 0 |
| `g:vim_vue_plugin_use_sass`              | Enable sass/scss syntax for `<style lang="sass">`(or scss).                                            | 0 |
| `g:vim_svelte_plugin_has_init_indent`    | Initially indent one tab inside `style/script` tags.                                                   | 1 |
| `g:vim_svelte_plugin_use_foldexpr`       | Enable builtin foldexpr fold method.                                                                   | 1 |
| `g:vim_svelte_plugin_debug`              | Echo debug messages in `messages` list. Useful to debug if unexpected indents occur.                   | 0 |

\*: Vim may be slow if the feature is enabled. Find a balance between syntax highlight and speed. By the way, custom syntax could be added in `~/.vim/syntax` or `$VIM/vimfiles/syntax`.

**Note**: `filetype` is set to `svelte` so autocmds and other settings for `javascript` have to be manually enabled for `svelte`.

**Note**:  See <https://svelte.dev/docs#svelte_preprocess> for how to use less/sass in svelte.

## Screenshot

<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-svelte-theme.png" width="600" />

> syntax color: [vim-svelte-theme][11]

## Context based behavior

As there are more than one language in `.svelte` file, the different behaviors like mapping or completion may be expected under different tags.

This plugin provides a function to get the tag where the cursor is in.

- `GetSvelteTag() => String` Return value is 'template', 'script' or 'style'.

### Example

```vim
autocmd FileType svelte inoremap <buffer><expr> : InsertColon()

function! InsertColon()
  let tag = GetSvelteTag()
  
  if tag == 'template'
    return ':'
  else
    return ': '
  endif
endfunction
```

### vim-emmet

Currently vim-emmet works regarding your HTML/CSS/JavaScript emmet settings, but it depends on how vim-emmet gets `filetype` and may change in the future. Feel free to report an issue if any problem appears.

## See also

- [vim-svelte-theme][11]
- [vim-vue-plugin][3]
- [mxw/vim-jsx][1]

## License

This plugin is under [The Unlicense][8].

[1]: https://github.com/mxw/vim-jsx "mxw: vim-jsx"
[2]: https://github.com/VundleVim/Vundle.vim
[3]: https://github.com/leafOfTree/vim-vue-plugin
[5]: https://github.com/tpope/vim-pathogen
[7]: https://github.com/junegunn/vim-plug
[8]: https://choosealicense.com/licenses/unlicense/
[10]: https://github.com/mattn/emmet-vim
[11]: https://github.com/leafOfTree/vim-svelte-theme
