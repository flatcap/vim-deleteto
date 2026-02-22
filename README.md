# deleteto.vim

## Introduction

DeleteTo reads a character from the user, then deletes from the beginning of the line up to and including that character.

DeleteUntil is similar, but deletes up to and **not** including the character.
This is analogous to Vim's `f` vs `t` motions.

If you have a tab delimited file, "dU<tab>" will delete the first column of data.

See the Workflow section, below, to see what that means.

To improve this plugin, I recommend installing Tim Pope's
[vim-repeat](https://github.com/tpope/vim-repeat) plugin.

## Workflow

Imagine you're working with a list of files:

```
./deleteto/plugin/deleteto.vim
./deleteto/README.md
./keyword/plugin/keyword.vim
./keyword/README.md
```

but you'd like a tidier list without the "./" at the beginning.
Type: `dU/`

```
deleteto/plugin/deleteto.vim
deleteto/README.md
keyword/plugin/keyword.vim
keyword/README.md
```

Type `dU/` again

```
plugin/deleteto.vim
README.md
plugin/keyword.vim
README.md
```

## Mappings

By default, DeleteTo creates four mappings:

| Type         | To work on     | Calls                 |
| :----------- | :------------- | :-------------------- |
| dU           | All lines      | &lt;Plug&gt;DeleteToA |
| duu          | This line      | &lt;Plug&gt;DeleteToL |
| du\{motion\} | Motion-defined | &lt;Plug&gt;DeleteToM |
| \{visual\}du | Visual region  | &lt;Plug&gt;DeleteToV |

You can disable the default mappings with:

```viml
let g:deleteto_create_mappings = 0
```

DeleteUntil does not create default mappings to avoid conflicts with
built-in Vim commands.  The following `<Plug>` targets are available:

| Plug target                       | To work on     |
| :-------------------------------- | :------------- |
| &lt;Plug&gt;DeleteUntilA          | All lines      |
| &lt;Plug&gt;DeleteUntilL          | This line      |
| &lt;Plug&gt;DeleteUntilM          | Motion-defined |
| &lt;Plug&gt;DeleteUntilV          | Visual region  |

Suggested mappings (add to your vimrc):

```viml
nmap dI  <Plug>DeleteUntilA
nmap dii <Plug>DeleteUntilL
nmap di  <Plug>DeleteUntilM
xmap di  <Plug>DeleteUntilV
```

## Commands

The commands have the form

  :[range]DeleteTo CHAR [COUNT]
  :[range]DeleteUntil CHAR [COUNT]

DeleteTo deletes including the delimiter character.
DeleteUntil deletes up to but not including the delimiter character.

## Examples

The delimiter will commonly be forward slash, space, comma or tab.
However, DeleteTo will work with any character, including multi-byte
characters.

| Type this           | Works on               | Delete up to this character |
| :------------------ | :--------------------- | :-------------------------- |
| dU/                 | Whole file             | First /                     |
| 3dU,                | Whole file             | Third ,                     |
| 4duu/               | One line               | Fourth /                    |
| vip2du&lt;tab&gt;   | Visual - paragraph     | Second &lt;tab&gt;          |
| du9j,               | Motion - 10 lines      | First ,                     |
|                     |                                                      |
| :DeleteTo /         | Whole file             | First /                     |
| :1,20DeleteTo /     | Lines 1-20             | First /                     |
| :DeleteTo , 4       | Whole file             | Fourth ,                    |
|                     |                                                      |
| :argdo DeleteTo / 2 | All args, all lines    | Second /                    |
| :bufdo DeleteTo \|  | All buffers, all lines | First \|                    |

### DeleteUntil (exclusive)

Given the line: `a/b/c/d`

| Command          | Result  | Deleted |
| :--------------- | :------ | :------ |
| :DeleteUntil /   | /b/c/d  | a       |
| :DeleteUntil / 2 | /c/d    | a/b     |
| :DeleteUntil / 3 | /d      | a/b/c   |

## Options

### Yank deleted text

By default, DeleteTo uses `:substitute` internally, so the deleted text is
not placed into any register.  This differs from Vim's built-in `d` command.

To yank the deleted text into the unnamed register, set:

```viml
let g:deleteto_yank = 1
```

This applies to both DeleteTo and DeleteUntil.  The deleted text from all
affected lines is joined with newlines and placed in the unnamed register,
so you can paste it with `p`.

## License

Copyright &copy; 2014-2026 Richard Russon (flatcap).
Distributed under the GPLv3 <http://fsf.org/>

## See also

- [flatcap.org](https://flatcap.org)
- [GitHub](https://github.com/flatcap/vim-deleteto)

