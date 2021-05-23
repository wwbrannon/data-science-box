#!/bin/bash

set -xe

cd

export HOSTHOME;
HOSTHOME=/mas/u/wbrannon

ln -s "$HOSTHOME/.ssh" .
ln -s "$HOSTHOME/.bash_local" .
ln -s "$HOSTHOME/.gitconfig_local" .
ln -s "$HOSTHOME/github" .
rmdir notebooks && ln -s "$HOSTHOME/notebooks" .

eval "$(ssh-agent)"
ssh-add ~/.ssh/id_rsa

git clone git@github.com:wwbrannon/dotfiles.git .dotfiles
cd .dotfiles && bash ./setup.sh

