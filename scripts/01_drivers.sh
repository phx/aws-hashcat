#!/bin/bash

apt-get update -yq
apt-get install -yq hashcat build-essential linux-headers-$(uname -r) unzip p7zip-full linux-image-extra-virtual

touch /etc/modprobe.d/blacklist-nouveau.conf
bash -c "echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf"
bash -c "echo 'blacklist lbm-nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf"
bash -c "echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nouveau.conf"
bash -c "echo 'alias nouveau off' >> /etc/modprobe.d/blacklist-nouveau.conf"
bash -c "echo 'alias lbm-nouveau off' >> /etc/modprobe.d/blacklist-nouveau.conf"

touch /etc/modprobe.d/nouveau-kms.conf
bash -c "echo 'options nouveau modeset=0' >>  /etc/modprobe.d/nouveau-kms.conf"
update-initramfs -u
