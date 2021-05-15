#!/bin/bash

set -xe

NVIDIA_VERSION=450

#
# Add software sources
#

apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg gnupg-agent apt-transport-https apt-utils \
    software-properties-common

## Docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
curl -sSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## NVIDIA container toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

dist=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L "https://nvidia.github.io/nvidia-docker/$dist/nvidia-docker.list" \
    > /etc/apt/sources.list.d/nvidia-docker.list

## R
# https://cran.r-project.org/bin/linux/ubuntu/README.html
apt-key adv --keyserver keyserver.ubuntu.com \
            --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository \
    "deb https://cloud.r-project.org/bin/linux/ubuntu \
    $(lsb_release -cs)-cran40/"

## Postgres
# https://wiki.postgresql.org/wiki/Apt#Quickstart
curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-add-repository \
    "deb http://apt.postgresql.org/pub/repos/apt/ \
    $(lsb_release -cs)-pgdg main"

##
## Apply updates and install packages
##

apt-get update && apt-get upgrade -y

apt-get install -y --no-install-recommends \
    "$(: Package management utilities)" \
    apt-file apt-rdepends apt-show-source apt-show-versions apt-clone \
    aptitude deborphan debootstrap debian-goodies \
    \
    "$(: Security stuff)" \
    unattended-upgrades ufw \
    \
    "$(: Traditional Unix build toolchain)" \
    build-essential gfortran binutils \
    autoconf automake m4 bison flex gdb libtool \
    linux-headers-generic linux-doc linux-source \
    \
    "$(: Other development utilities)" \
    vim git subversion wget jq pkg-config shellcheck python3-dev python3-pip \
    python3-venv bzip2 gzip zip unzip \
    \
    "$(: Database stuff)" \
    sqlite3 unixodbc unixodbc-dev odbc-postgresql pgtop \
    postgresql-client mysql-client libpq-dev \
    \
    "$(: Misc utilities)" \
    dos2unix uni2ascii w3m lm-sensors locate mailutils parted pv rlwrap \
    screen zip unzip nmap netcat wamerican memstat members diffutils \
    locales tzdata \
    \
    "$(: Docker)" \
    docker-ce docker-ce-cli containerd.io \
    \
    "$(: NVIDIA stuff)" \
    "nvidia-headless-$NVIDIA_VERSION" "nvidia-utils-$NVIDIA_VERSION" \
    nvidia-docker2

## Docker-compose
# the Docker repo doesn't bundle the most up-to-date version as an apt package
pip3 install docker-compose

#
# Security
#

ufw disable # if already installed, turn off before making changes

ufw --force reset # drop any current config

ufw default deny incoming # rules
ufw default allow outgoing
ufw limit ssh/tcp

ufw --force enable # turn it on

