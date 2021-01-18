# box-config

## Base system setup
First things first: install the base ubuntu system from the local console. Some
important points:
* Set root's password.
* Make sure to install the ssh server! Update `/etc/ssh/sshd_config` with
  desired configuration.
* Personalization: Install your public key, set up ssh key forwarding or
  generate a new public key + register it with github, clone and install your
  dotfiles.
* Reboot to confirm bootable.

## Next up:
* Clone this repo
* Install CA cert or generate new one
* Generate new site.{pem,key}

* `./setup.sh`

* add yourself to the docker group: `usermod -a -G docker $(whoami)`

