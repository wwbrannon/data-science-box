#!/bin/bash

set -xe

#
# Deploy application stack
#

mkdir -p ~/.dkc-stacks/
cp -Rf stack start.sh stop.sh ~/.dkc-stacks/
chmod u+x ~/.dkc-stacks/{start,stop}.sh

mkdir -p ~/.config/systemd/user/
cp -f docker-compose@.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable docker-compose@stack
systemctl --user restart docker-compose@stack # restart also works if not running

