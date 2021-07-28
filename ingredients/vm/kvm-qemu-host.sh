#!/bin/bash
#|#./ingredients/vm/kvm-qemu-host.sh #KVM/QEMU host installation and configuration

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

# Installs all the neccessary packages to support running / managing KVM virtual machines
# Note edk2-ovmf supports VMs with UEFI instead of traditional BIOS
paru -S --noconfirm --needed qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat iptables-nft edk2-ovmf dmidecode

# Tweak some permissions for libvirtd to allow non-root users to interact with KVM virtual machines
sudo sed -i "s/#unix_sock_group/unix_sock_group/" "/etc/libvirt/libvirtd.conf"
sudo sed -i "s/#unix_sock_ro_perms/unix_sock_ro_perms/" "/etc/libvirt/libvirtd.conf"

# Add user to the correct groups
sudo usermod -a -G libvirt $USER

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

sudo virsh net-start default
sudo virsh net-autostart default

echo "===/etc/libvirt/qemu/networks/default.xml==="
sudo cat /etc/libvirt/qemu/networks/default.xml
echo "============================================"

sudo virsh net-list --all

echo -e "${YELLOW}Warning: you will need to reboot in order for the configuration changes to take affect.${NC}"
