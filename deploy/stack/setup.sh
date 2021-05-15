#!/bin/bash

set -xe

cd

ln -s /mas/u/wbrannon/.ssh
ln -s /mas/u/wbrannon/.bash_local
ln -s /mas/u/wbrannon/.gitconfig_local
ln -s /mas/u/wbrannon/github
rmdir notebooks && ln -s /mas/u/wbrannon/notebooks

eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

git clone git@github.com:wwbrannon/dotfiles.git .dotfiles
cd .dotfiles && bash ./setup.sh
