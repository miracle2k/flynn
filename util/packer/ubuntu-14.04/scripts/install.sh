#!/bin/bash
set -xeo pipefail

# enable memory and swap cgroup
perl -p -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/g'  /etc/default/grub
/usr/sbin/update-grub

# add docker group and add vagrant to it
sudo groupadd docker
sudo usermod -a -G docker vagrant

# add the docker, tup and flynn gpg keys
apt-key adv --keyserver keyserver.ubuntu.com --recv 36A1D7869245C8950F966E92D8576A8BA88D21E9
apt-key adv --keyserver keyserver.ubuntu.com --recv E601AAF9486D3664
apt-key adv --keyserver keyserver.ubuntu.com --recv BC79739C507A9B53BB1B0E7D820A5489998D827B

echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
echo deb https://dl.flynn.io/ubuntu flynn main > /etc/apt/sources.list.d/flynn.list
echo deb http://ppa.launchpad.net/anatol/tup/ubuntu precise main > /etc/apt/sources.list.d/tup.list

apt-get update
apt-get install -y curl vim-tiny git mercurial bzr make lxc-docker linux-image-extra-$(uname -r) libdevmapper-dev btrfs-tools libvirt-dev ruby2.0 ruby2.0-dev flynn-host tup

gem2.0 install fpm --no-rdoc --no-ri

mkdir -p /var/lib/docker
flynn-release download /etc/flynn/version.json

# Disable container auto-restart when docker starts
sed -i 's/^#DOCKER_OPTS=.*/DOCKER_OPTS="-r=false"/' /etc/default/docker

# install Go
cd /tmp
wget j.mp/godeb
tar xvzf godeb
./godeb install
