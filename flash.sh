#!/bin/bash
set -x
set -e
gunzip -c -k liox6-uefi.raw.gz | sudo dd of=/dev/nvme0n1 status=progress
sync
sudo mkdir /mnt1
sudo mount /dev/nvme0n1p3 /mnt1
sudo sed 's/resize2fs.*/resize2fs \/dev\/nvme0n1p3'
systemctl poweroff
