# deleteto.vim

DeleteTo creates a set of mappings to trim the beginning of lines.

## Examples

### Whole File

Imagine you're working with a list of files:

    ./deleteto/plugin/deleteto.vim
    ./deleteto/README.md
    ./keyword/plugin/keyword.vim
    ./keyword/README.md

but you'd like a tidier list without the "./" at the beginning.
Type: `dU/`

    deleteto/plugin/deleteto.vim
    deleteto/README.md
    keyword/plugin/keyword.vim
    keyword/README.md

Type `dU/` again

    plugin/deleteto.vim
    README.md
    plugin/keyword.vim
    README.md

### Ranges

Normal mode: `du/` works on a line.

Visual mode: `du/` works on range.

## License

Copyright &copy; Richard Russon (flatcap).
Distributed under the GPLv3 <http://fsf.org/>

## See also

- [flatcap.org](https://flatcap.org)
- [GitHub](https://github.com/flatcap/vim-deleteto)

