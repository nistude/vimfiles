# This is my vim setup.

I'm using pathogen to keep all my vim plugins in separate directories,
and git submodules to manage both pathogen itself and all the plugins.

## Getting started

To get started, just move your existing .vim and .vimrc out of the way and
type the following from wherever you want to install:

    git clone --recursive git://github.com/nistude/vimfiles.git
    ln -s $PWD/vim ~/.vim
    ln -s $PWD/vimrc ~/.vimrc

## Adding new submodules

    git add submodule <repository> <path>

Add `ignore = untracked` to the new submodule's entry in .gitmodules and
commit everything.
