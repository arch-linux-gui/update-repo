#!/bin/bash

# Change to the directory
#cd ~/Desktop/ALG/arch-linux-gui-gnome/
git checkout -b dev master

# Remove unnecessary files
rm -rf airootfs/etc/systemd/system/etc-pacman.d-gnupg.mount \
    .gitignore \
    git_commit.sh \
    pacman.conf \
    grub/grub.cfg \
    airootfs/etc/xdg/reflector/reflector.conf \
    airootfs/etc/mkinitcpio.conf \
    airootfs/usr/local/bin/alg-finalisation \
    airootfs/etc/systemd/journald.conf \
    airootfs/etc/systemd/logind.conf \
    airootfs/etc/systemd/system-generators/systemd-gpt-auto-generator \
    airootfs/etc/systemd/system/multi-user.target.wants/hv_fcopy_daemon.service \
    airootfs/etc/systemd/system/multi-user.target.wants/hv_kvp_daemon.service \
    airootfs/etc/systemd/system/multi-user.target.wants/hv_vss_daemon.service \
    airootfs/etc/systemd/system/multi-user.target.wants/vmtoolsd.service \
    airootfs/etc/systemd/system/multi-user.target.wants/vmware-vmblock-fuse.service \
    airootfs/etc/systemd/system/livecd-alsa-unmuter.service \
    airootfs/etc/systemd/system/livecd-talk.service \
    airootfs/etc/systemd/system/pacman-init.service \
    airootfs/etc/pacman.conf \
    airootfs/etc/skel/.bashrc \
    airootfs/etc/systemd/system/dbus-org.freedesktop.timesync1.service

# Define the repository directory
repo=../arch-linux-gui-cinnamon

# Copy files from the repository directory to the current directory
cp "$repo/airootfs/etc/systemd/system/etc-pacman.d-gnupg.mount" airootfs/etc/systemd/system/
cp "$repo/.gitignore" .gitignore
cp "$repo/pacman.conf" pacman.conf
mkdir -p grub
cp -r "$repo/grub/grub.cfg" grub/
cp -r "$repo/grub/loopback.cfg" grub/
cp "$repo/airootfs/etc/xdg/reflector/reflector.conf" airootfs/etc/xdg/reflector/
cp "$repo/airootfs/etc/mkinitcpio.conf" airootfs/etc/
cp "$repo/airootfs/usr/local/bin/alg-finalisation" airootfs/usr/local/bin/
mkdir -p airootfs/etc/systemd/system-generators
cp -r "$repo/airootfs/etc/systemd/system-generators/systemd-gpt-auto-generator" airootfs/etc/systemd/system-generators/systemd-gpt-auto-generator
cp -r "$repo/airootfs/etc/systemd/system/multi-user.target.wants/hv_fcopy_daemon.service" airootfs/etc/systemd/system/multi-user.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/multi-user.target.wants/hv_kvp_daemon.service" airootfs/etc/systemd/system/multi-user.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/multi-user.target.wants/hv_vss_daemon.service" airootfs/etc/systemd/system/multi-user.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/multi-user.target.wants/vmtoolsd.service" airootfs/etc/systemd/system/multi-user.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/multi-user.target.wants/vmware-vmblock-fuse.service" airootfs/etc/systemd/system/multi-user.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/livecd-alsa-unmuter.service" airootfs/etc/systemd/system/
cp -r "$repo/airootfs/etc/systemd/system/livecd-talk.service" airootfs/etc/systemd/system/
cp -r "$repo/airootfs/etc/systemd/system/pacman-init.service" airootfs/etc/systemd/system/
cp -r "$repo/airootfs/etc/pacman.conf" airootfs/etc/
cp -r "$repo/airootfs/etc/skel/.bashrc" airootfs/etc/skel/
cp -r "$repo/airootfs/etc/systemd/system/dbus-org.freedesktop.timesync1.service" airootfs/etc/systemd/system/
cp -r "$repo/airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf" airootfs/etc/systemd/system/getty@tty1.service.d/
mkdir -p airootfs/etc/systemd/system/sysinit.target.wants
cp -r "$repo/airootfs/etc/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service" airootfs/etc/systemd/system/sysinit.target.wants/
cp -r "$repo/airootfs/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service" airootfs/etc/systemd/system/sysinit.target.wants/

# Remove specified packages from packages.x86_64
sed -i '/ipw2100-fw/d' packages.x86_64
sed -i '/ipw2200-fw/d' packages.x86_64
sed -i '/bind-tools/d' packages.x86_64
sed -i '/crda/d' packages.x86_64


packages=("bcachefs-tools" "bind" "linux-firmware-marvell" "pv" "qemu-guest-agent" "vim")
file="packages.x86_64"

# Check if each package already exists in the file
for pkg in "${packages[@]}"; do
    if ! grep -q "^$pkg$" "$file"; then
        # If the package does not exist, add it to the file
        sed -i "/# SPDX-License-Identifier: GPL-3.0-or-later/a $pkg" "$file"
    fi
done

# Change "archlinux-gui" to "alg" in profiledef.sh
sed -i 's/archlinux-gui/alg/g' profiledef.sh

# Change "ARCH_GUI" to "ALG" in profiledef.sh
sed -i 's/ARCH_GUI/ALG/g' profiledef.sh

# Change "Arch Linux GUI" to "ALG" in profiledef.sh
sed -i 's/Arch Linux GUI/ALG/g' profiledef.sh

# Replace the line with the new bootmodes in profiledef.sh
sed -i "s/bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')/bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp' 'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')/g" profiledef.sh
