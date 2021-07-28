#!/bin/bash
#|#./ingredients/vm/kvm-qemu-guest.sh #KVM/QEMU guest utilities (only install if running as VM)

# Install Qemu guest agent and Spice tools
paru -S --noconfirm --needed qemu-guest-agent spice-vdagent

# Enable the Qemu guest agent service
sudo systemctl enable qemu-guest-agent.service
sudo systemctl start qemu-guest-agent.service
