# jump.vim

Brings the power of [Autojump](https://github.com/joelthelion/autojump) to Vim.

The `:J` command defined by jump.vim is meant as a replacement for Vim's built
in `:cd` command. If you are looking for a way to replace Vim's `:e` command,
you might be looking for [autojump.vim](https://github.com/trotter/autojump.vim)

## Installation

Installation using Vundle is recommended

    Plugin 'padde/jump.vim'

This plugin depends on Autojump. For installation instructions please refer to

https://github.com/joelthelion/autojump

## Usage

jump.vim defines the following commands:

### `:J`

Equivalent to Autojump's `j` command – switch working directory. For example
```:J dot``` should take you to your `~/.dotfiles` directory.

### `:Jc`

Equivalent to Autojump's `jc` command – switch working directory, limiting the
search to subdirectories of the current working directory.

### `:Jo`

Equivalent to Autojump's `jo` command – open directory in system file explorer.

### `:Jco`

Equivalent to Autojump's `jco` command – open directory in system file explorer,
limiting the search to subdirectories of the current working directory.

### `:Cd`

Replacement for Vim's built-in `:cd` command. Behaves exactly the same, except
that this version keeps track of the directories you visit. Useful if a
directory is not recognized by Autojump and you want to add it to the list of
available shortcuts. Next time you use one of the above commands, Autojump will
know about the new directory.

## Configuration

jump.vim tries to auto-detect the location of your Autojump installation. In
case the detection fails, you will see the following error message when trying
to use one of jump.vim's commands:

    autojump not found - please install it or set g:autojump_executable

If you installed Autojump in a non-standard location, you can set the path to
the autojump script manually:

    let g:autojump_executable = "path/to/autojump.sh"

## Boring Legal Stuff

Copyright (c) Patrick Oscity. Distributed under the same terms as Vim itself.
See `:help license`
