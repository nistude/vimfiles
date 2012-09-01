#!/bin/bash

basedir=`pwd`

git pull
git submodule foreach git pull origin master
cd vim/bundle/vim-powerline && git pull origin develop
cd $basedir
git commit -m 'update plugins' vim-pathogen vim/bundle
