# deleteto.vim

## Introduction

DeleteTo reads a character from the user, then deletes from the beginning of the line up to and including that character.

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
| ------------ | -------------- | --------------------- |
| dU           | All lines      | &lt;Plug&gt;DeleteToA |
| duu          | This line      | &lt;Plug&gt;DeleteToL |
| du\{motion\} | Motion-defined | &lt;Plug&gt;DeleteToM |
| \{visual\}du | Visual region  | &lt;Plug&gt;DeleteToV |

You can disable the default mappings with:

```viml
let g:deleteto_create_mappings = 0
```

## Command

The DeleteTo command has the form

  :[range]DeleteTo CHAR [COUNT]

## Examples

The delimiter will commonly be forward slash, space, comma or tab.
However, DeleteTo will work with any character, including multi-byte
characters.

| Type this           | Works on               | Delete up to this character |
| ------------------- | ---------------------- | --------------------------- |
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

## License

Copyright &copy; Richard Russon (flatcap).
Distributed under the GPLv3 <http://fsf.org/>

## See also

- [flatcap.org](https://flatcap.org)
- [GitHub](https://github.com/flatcap/vim-deleteto)

