#!/usr/bin/env bash
#
# # Mount vboxsf
# $ sudo mount -t vboxsf vbox ~/synced

set -uex

v=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
curl http://download.virtualbox.org/virtualbox/${v}/VBoxGuestAdditions_${v}.iso -o /tmp/vbga.iso
sudo mount -t iso9660 /tmp/vbga.iso /mnt/
sudo /mnt/VBoxLinuxAdditions.run
