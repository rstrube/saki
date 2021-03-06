#!/bin/bash
# Simple Arch KDE Installer

# Configuration
#################################################

# HD Configuration
# Run "lsblk" to determine HD device name
# To check for TRIM support, run "lsblk --discard". If DISC-GRAN && DISC-MAX are > 0, your HD supports TRIM.
# If running as VM, you'll need to double check if TRIM is supported.  Newer KVM/Qemu VMs should support TRIM.
HD_DEVICE="" # /dev/sda /dev/nvme0n1 /dev/vda
TRIM_SUPPORT="true" # typically set to true if HD is an SSD, see notes above
SWAPFILE_SIZE="2048" # 4096 8912 (in MiB)

# CPU Configuration
# Note: if installing in a VM leave both set to 'false'
AMD_CPU="false"
INTEL_CPU="false"

# GPU Configuration
AMD_GPU="false"
INTEL_GPU="false"
NVIDIA_GPU="false"

# Hostname to ping to check network connection
PING_HOSTNAME="www.google.com"

# Hostname Configuration
HOSTNAME="saki"

# Locale Configuration
# To list out all timezones in US run "ls -l /usr/share/zoneinfo/America"
KEYS="us"
TIMEZONE="/usr/share/zoneinfo/America/Denver"
LOCALE="en_US.UTF-8 UTF-8"
LANG="en_US.UTF-8"
REFLECTOR_COUNTRY="United States"

# User Configuration
ROOT_PASSWORD=""
USER_NAME=""
USER_PASSWORD=""

# Additional Linux Command Line Params
CMDLINE_LINUX="" #"msr.allow_writes=on"

# Installation Scripts
#################################################

function main() {
    check_critical_prereqs
    check_variables
    check_conflicts
    check_network

    loadkeys $KEYS

    confirm_install
    install
}

function install() {
    
    # 1. System clock and initial reflector pass
    # ------------------------------------------
    # Update system clock
    timedatectl set-ntp true

    # Select the fastest pacman mirrors
    reflector --verbose --country "$REFLECTOR_COUNTRY" --latest 25 --sort rate --save /etc/pacman.d/mirrorlist

    # 2. HD partitioning and formatting
    # ---------------------------------
    # Partion the drive with a single 512 MB ESP partition, and the rest of the drive as the root partition
    parted -s $HD_DEVICE mklabel gpt mkpart ESP fat32 1MiB 512MiB mkpart root ext4 512MiB 100% set 1 esp on

    # Is the the hard drive an NVME SSD?
    if [[ -n "$(echo $HD_DEVICE | grep "^/dev/nvme")" ]]; then
        BOOT_PARTITION="${HD_DEVICE}p1"
        ROOTFS_PARTITION="${HD_DEVICE}p2"
    else
        BOOT_PARTITION="${HD_DEVICE}1"
        ROOTFS_PARTITION="${HD_DEVICE}2"
    fi

    # Create the filesystem for the ESP partition
    mkfs.fat -n ESP -F32 $BOOT_PARTITION

    # Create the filesystem for the root partition
    yes | mkfs.ext4 -L ROOT $ROOTFS_PARTITION

    # Mount the root partition
    mount -o defaults,noatime $ROOTFS_PARTITION /mnt

    # Create directory to support mounting ESP
    mkdir /mnt/boot

    # Mount the ESP partition
    mount -o defaults,noatime $BOOT_PARTITION /mnt/boot

    # Build out swapfile
    SWAPFILE="/swapfile"
    fallocate --length ${SWAPFILE_SIZE}MiB /mnt"$SWAPFILE"
    chown root /mnt"$SWAPFILE"
    chmod 600 /mnt"$SWAPFILE"
    mkswap /mnt"$SWAPFILE"

    # 3. Initial pacstrap and core packages
    # -------------------------------------
    # Force a refresh of the archlinux-keyring package for the arch installation environment
    pacman -Sy --noconfirm archlinux-keyring

    # Bootstrap new environment
    pacstrap /mnt

    # Install essential packages
    arch-chroot /mnt pacman -S --noconfirm --needed \
        base-devel              `# Core development libraries (gcc, etc.)` \
        linux linux-headers     `# Linux kernel and headers` \
        iptables-nft            `# Newer firewall config with many benefits over traditional iptables` \
        fwupd                   `# Support for updating firmware from Linux Vendor Firmware Service [https://fwupd.org/]` \
        man-db man-pages        `# man pages` \
        texinfo                 `# GUN documentation format` \
        dosfstools exfatprogs   `# Tools and utilities for FAT and exFAT filesystems` \
        e2fsprogs               `# Tools and utiltiies for ext filesystems` \
        networkmanager          `# Networkmanager` \
        git                     `# Git` \
        vim                     `# Text editor` \
        cpupower                `# Tool for managing your CPU frequency and governor` \
        reflector               `# Utility to manage pacman mirrors`

    # Install additional firmware and uCode
    if [[ "$AMD_CPU" == "true" ]]; then
        arch-chroot /mnt pacman -S --noconfirm --needed linux-firmware amd-ucode
        MICROCODE="amd-ucode.img"

    elif [[ "$INTEL_CPU" == "true" ]]; then
        arch-chroot /mnt pacman -S --noconfirm --needed linux-firmware intel-ucode
        MICROCODE="intel-ucode.img"
    fi

    # 4. Core system configuration
    # ----------------------------
    # Enable systemd-resolved local caching DNS provider
    # Note: NetworkManager uses systemd-resolved by default
    arch-chroot /mnt systemctl enable systemd-resolved.service

    # Enable NetworkManager.service
    # Note: NetworkManager will handle DHCP
    arch-chroot /mnt systemctl enable NetworkManager.service

    # Enable bluetooth.service
    arch-chroot /mnt systemctl enable bluetooth.service

    # Configure color support for pacman
    arch-chroot /mnt sed -i 's/#Color/Color/' /etc/pacman.conf

    # Enable multilib
    arch-chroot /mnt sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    arch-chroot /mnt pacman -Syyu

    # Generate initial fstab using UUIDs
    genfstab -U /mnt > /mnt/etc/fstab

    # Create a dedicated entry for swapfile
    echo "# swapfile" >> /mnt/etc/fstab
    echo "$SWAPFILE none swap defaults 0 0" >> /mnt/etc/fstab
    echo "" >> /mnt/etc/fstab

    # Configure swappiness paramater (default=60) to improve system responsiveness
    echo "vm.swappiness=10" > /mnt/etc/sysctl.d/99-sysctl.conf

    # Enable periodic trim if the HD supports TRIM
    if [[ "$TRIM_SUPPORT" == "true" ]]; then
        arch-chroot /mnt systemctl enable fstrim.timer
    fi

    # Configure timezone and system clock
    arch-chroot /mnt ln -s -f $TIMEZONE /etc/localtime
    arch-chroot /mnt hwclock --systohc

    # Configure locale
    arch-chroot /mnt sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen
    arch-chroot /mnt locale-gen
    echo -e "LANG=$LANG" >> /mnt/etc/locale.conf

    # Configure keymap for virtual console (tty)
    echo -e "KEYMAP=$KEYS" > /mnt/etc/vconsole.conf

    # Configure hostname and hosts files
    echo $HOSTNAME > /mnt/etc/hostname
    echo "127.0.0.1	localhost" >> /mnt/etc/hosts
    echo "::1 localhost" >> /mnt/etc/hosts
    echo "127.0.0.1	${HOSTNAME}.localdomain $HOSTNAME" >> /mnt/etc/hosts

    # Configure root password
    printf "$ROOT_PASSWORD\n$ROOT_PASSWORD" | arch-chroot /mnt passwd

    # Configure reflector
    echo "--save /etc/pacman.d/mirrorlist" > /mnt/etc/xdg/reflector/reflector.conf
    echo "--country \"$REFLECTOR_COUNTRY\"" >> /mnt/etc/xdg/reflector/reflector.conf
    echo "--protocol https" >> /mnt/etc/xdg/reflector/reflector.conf
    echo "--latest 25" >> /mnt/etc/xdg/reflector/reflector.conf
    echo "--sort rate" >> /mnt/etc/xdg/reflector/reflector.conf

    # 5. Bootloader configuration (systemd-boot)
    # ------------------------------------------
    # Add KMS if using a NVIDIA GPU
    if [[ "$NVIDIA_GPU" == "true" ]]; then
        CMDLINE_LINUX="$CMDLINE_LINUX nvidia-drm.modeset=1"
    fi

    CMDLINE_LINUX=$(trim_variable "$CMDLINE_LINUX")

    # Note: standard hooks for /etc/mkinitcpio.conf are: (base udev autodetect modconf block filesystems keyboard fsck)
    # This updates the standard hooks to support systemd-boot
    arch-chroot /mnt sed -i "s/^HOOKS=(.*)$/HOOKS=(base systemd autodetect modconf block filesystems keyboard sd-vconsole fsck)/" /etc/mkinitcpio.conf

    # Need to rebuild the initramfs after updating hooks
    arch-chroot /mnt mkinitcpio -P

    # Get the UUID for the root partition
    UUID_ROOTFS_PARTITION=$(blkid -s UUID -o value "$ROOTFS_PARTITION")
    CMDLINE_LINUX_ROOT="root=UUID=$UUID_ROOTFS_PARTITION"

    arch-chroot /mnt systemd-machine-id-setup
    arch-chroot /mnt bootctl install

    arch-chroot /mnt mkdir -p /boot/loader
    arch-chroot /mnt mkdir -p /boot/loader/entries

    # Main systemd-boot config
    echo "timeout 5" >> "/mnt/boot/loader/loader.conf"
    echo "default archlinux.conf" >> "/mnt/boot/loader/loader.conf"
    echo "editor 1" >> "/mnt/boot/loader/loader.conf"

    # Config for normal boot
    echo "title Arch Linux" >> "/mnt/boot/loader/entries/archlinux.conf"
    echo "efi /vmlinuz-linux" >> "/mnt/boot/loader/entries/archlinux.conf"
    if [ -n "$MICROCODE" ]; then
        echo "initrd /$MICROCODE" >> "/mnt/boot/loader/entries/archlinux.conf"
    fi
    echo "initrd /initramfs-linux.img" >> "/mnt/boot/loader/entries/archlinux.conf"
    echo "options initrd=initramfs-linux.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX" >> "/mnt/boot/loader/entries/archlinux.conf"

    # Config for booting into terminal only
    echo "title Arch Linux (terminal)" >> "/mnt/boot/loader/entries/archlinux-terminal.conf"
    echo "efi /vmlinuz-linux" >> "/mnt/boot/loader/entries/archlinux-terminal.conf"
    if [ -n "$MICROCODE" ]; then
        echo "initrd /$MICROCODE" >> "/mnt/boot/loader/entries/archlinux-terminal.conf"
    fi
    echo "initrd /initramfs-linux.img" >> "/mnt/boot/loader/entries/archlinux-terminal.conf"
    echo "options initrd=initramfs-linux.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX systemd.unit=multi-user.target" >> "/mnt/boot/loader/entries/archlinux-terminal.conf"

    # Config for fallback boot (uses old initramfs)
    echo "title Arch Linux (fallback)" >> "/mnt/boot/loader/entries/archlinux-fallback.conf"
    echo "efi /vmlinuz-linux" >> "/mnt/boot/loader/entries/archlinux-fallback.conf"
    if [ -n "$MICROCODE" ]; then
        echo "initrd /$MICROCODE" >> "/mnt/boot/loader/entries/archlinux-fallback.conf"
    fi
    echo "initrd /initramfs-linux-fallback.img" >> "/mnt/boot/loader/entries/archlinux-fallback.conf"
    echo "options initrd=initramfs-linux-fallback.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX" >> "/mnt/boot/loader/entries/archlinux-fallback.conf"

    # 6. User configuration
    # ---------------------
    # Setup user and allow user to use "sudo"
    arch-chroot /mnt useradd -m -G wheel,storage,optical -s /bin/bash $USER_NAME
    printf "$USER_PASSWORD\n$USER_PASSWORD" | arch-chroot /mnt passwd $USER_NAME
    arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    # 7. DE & audio system configuration
    # ----------------------------------
    # Install KDE
    arch-chroot /mnt pacman -S --noconfirm --needed \
        plasma plasma-wayland-session       `# KDE Plasma + Wayland Support` \
        plasma-nm                           `# NetworkManager applet` \
        kwallet kwallet-pam kwalletmanager  `# KWallet subsystem` \
        konsole                             `# Common KDE apps and utilities` \
        dolphin dolphin-plugins ark \
        kdenetwork-filesharing \
        kdegraphics-thumbnailers \
        ffmpegthumbs \
        okular gwenview kwrite kcalc \
        kimageformats qt5-imageformats \
        kcharselect \
        partitionmanager \
        ksystemlog \
        pipewire wireplumber                `# Pipewire and wireplumber session manager` \
        pipewire-pulse                      `# Pipewire drop in replacement for PulseAudio` \
        pipewire-jack                       `# Pipewire JACK support` \
        xdg-desktop-portal                  `# Support for screensharing in pipewire for KDE` \
        xdg-desktop-portal-kde \
        noto-fonts noto-fonts-emoji         `# Noto fonts to support emojis` \
        rust                                `# Rust for paru AUR helper`

    # Note: systemctl enable --user doesn't work via arch-chroot, performing manual creation of symlinks
    # systemctl enable --user --now pipewire.service
    # systemctl enable --user --now pipewire-pulse.service
    arch-chroot -u $USER_NAME /mnt mkdir -p /home/${USER_NAME}/.config/systemd/user/default.target.wants
    arch-chroot -u $USER_NAME /mnt mkdir -p /home/${USER_NAME}/.config/systemd/user/sockets.target.wants

    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/pipewire.service /home/${USER_NAME}/.config/systemd/user/default.target.wants/pipewire.service
    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/pipewire.socket /home/${USER_NAME}/.config/systemd/user/sockets.target.wants/pipewire.socket

    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/pipewire-pulse.service /home/${USER_NAME}/.config/systemd/user/default.target.wants/pipewire-pulse.service
    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/pipewire-pulse.socket /home/${USER_NAME}/.config/systemd/user/sockets.target.wants/pipewire-pulse.socket

    # systemctl enable --user --now wireplumber.service
    arch-chroot -u $USER_NAME /mnt mkdir -p /home/${USER_NAME}/.config/systemd/user/pipewire.service.wants

    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/wireplumber.service /home/${USER_NAME}/.config/systemd/user/pipewire-session-manager.service
    arch-chroot -u $USER_NAME /mnt ln -s /usr/lib/systemd/user/wireplumber.service /home/${USER_NAME}/.config/systemd/user/pipewire.service.wants/wireplumber.service

    # Enable SDDM as the default Display Manager
    arch-chroot /mnt systemctl enable sddm.service

    # Configure SDDM to use a sane theme (breeze)
    configure_sddm

    # 8. GPU Configuration
    # --------------------
    # Install GPU Drivers
    COMMON_VULKAN_PACKAGES="vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools"

    # Drivers for VM guest installations
    if [[ "$INTEL_GPU" == "false" && "$AMD_GPU" == "false" && "$NVIDIA_GPU" == "false" ]]; then
        arch-chroot /mnt pacman -S --noconfirm --needed $COMMON_VULKAN_PACKAGES mesa lib32-mesa
    fi

    if [[ "$INTEL_GPU" == "true" ]]; then
        # Note: installing newer intel-media-driver (iHD) instead of libva-intel-driver (i965)
        # Intel drivers only supports VA-API
        arch-chroot /mnt pacman -S --noconfirm --needed $COMMON_VULKAN_PACKAGES mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver libva-utils
        arch-chroot /mnt echo "LIBVA_DRIVER_NAME=iHD" >> /etc/environment
    fi

    if [[ "$AMD_GPU" == "true" ]]; then
        # AMDGPU supports both VA-API and VDPAU, but we're only installing support for VA-API
        arch-chroot /mnt pacman -S --noconfirm --needed $COMMON_VULKAN_PACKAGES mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver libva-utils
        arch-chroot /mnt echo "LIBVA_DRIVER_NAME=radeonsi" >> /etc/environment
    fi
    
    if [[ "$NVIDIA_GPU" == "true" ]]; then
        arch-chroot /mnt pacman -S --noconfirm --needed $COMMON_VULKAN_PACKAGES nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings

        # Configure pacman to rebuild the initramfs each time the nvidia package is updated
        configure_pacman_nvidia_hook
    fi

    # 9. AUR configuration
    # --------------------
    # Install AUR helper
    install_aur_helper

    # Install AUR packages
    # exec_as_user "paru -S --noconfirm --needed xxx"

    # 10. Additional pacman hooks
    # ---------------------------
    # Configure pacman hook for upgrading pacman-mirrorlist package
    configure_pacman_mirrorupgrade_hook

    # Configure pacman hook for updating systemd-boot when systemd is updated
    configure_pacman_systemd_boot_hook

    # 11. Clone repo for additional ingredients
    # -----------------------------------------
    # Clone saki git repo so that user can run post-install recipe
    arch-chroot -u $USER_NAME /mnt git clone https://github.com/rstrube/saki.git /home/${USER_NAME}/saki
    
    echo -e "${LIGHT_BLUE}Installation has completed! Run 'reboot' to reboot your machine.${NC}"
}

function check_critical_prereqs() {
    check_variables_value "HD_DEVICE" "$HD_DEVICE"
    
    if [[ ! -e "$HD_DEVICE" ]]; then
        echo -e "${RED}Error: HD_DEVICE="$HD_DEVICE" does not exist.${NC}"
        exit 1
    fi

    if [[ ! -d /sys/firmware/efi ]]; then
        echo -e "${RED}Error: installation can only be run on UEFI systems.${NC}"
        echo "If running in a VM, make sure the VM is configured to use UEFI instead of BIOS."
        exit 1
    fi
}

function check_variables() {
    check_variables_value "HD_DEVICE" "$HD_DEVICE"
    check_variables_boolean "TRIM_SUPPORT" "$TRIM_SUPPORT"
    check_variables_value "SWAPFILE_SIZE" "$SWAPFILE_SIZE"
    check_variables_boolean "AMD_CPU" "$AMD_CPU"
    check_variables_boolean "INTEL_CPU" "$INTEL_CPU"
    check_variables_boolean "AMD_GPU" "$AMD_GPU"
    check_variables_boolean "INTEL_GPU" "$INTEL_GPU"
    check_variables_boolean "NVIDIA_GPU" "$NVIDIA_GPU"
    check_variables_value "PING_HOSTNAME" "$PING_HOSTNAME"
    check_variables_value "HOSTNAME" "$HOSTNAME"
    check_variables_value "TIMEZONE" "$TIMEZONE"
    check_variables_value "KEYS" "$KEYS"
    check_variables_value "LOCALE" "$LOCALE"
    check_variables_value "LANG" "$LANG"
    check_variables_value "REFLECTOR_COUNTRY" "$REFLECTOR_COUNTRY"
    check_variables_value "ROOT_PASSWORD" "$ROOT_PASSWORD"
    check_variables_value "USER_NAME" "$USER_NAME"
    check_variables_value "USER_PASSWORD" "$USER_PASSWORD"
}

ERROR_VARS_MESSAGE="${RED}Error: you must edit saki.sh (e.g. with vim) and configure the required variables.${NC}"

function check_variables_value() {
    local NAME=$1
    local VALUE=$2
    if [[ -z "$VALUE" ]]; then
        echo -e $ERROR_VARS_MESSAGE
        echo "$NAME must have a value."
        exit 1
    fi
}

function check_variables_boolean() {
    local NAME=$1
    local VALUE=$2
    case $VALUE in
        true )
            ;;
        false )
            ;;
        * )
            echo -e $ERROR_VARS_MESSAGE
            echo "$NAME must be {true|false}."
            exit 1
            ;;
    esac
}

function trim_variable() {
    local VARIABLE="$1"
    local VARIABLE=$(echo "$VARIABLE" | sed 's/^[[:space:]]*//') # trim leading
    local VARIABLE=$(echo "$VARIABLE" | sed 's/[[:space:]]*$//') # trim trailing
    echo "$VARIABLE"
}

function print_variables_value() {
    local NAME=$1
    local VALUE=$2
    echo -e "$NAME = ${WHITE}${VALUE}${NC}"
}

function print_variables_boolean() {
    local NAME=$1
    local VALUE=$2
    if [[ "$VALUE" == "true" ]]; then
        echo -e "$NAME = ${GREEN}${VALUE}${NC}"
    else
        echo -e "$NAME = ${RED}${VALUE}${NC}"
    fi
}

function check_conflicts() {
    if [[ "$AMD_CPU" == "true" && "$INTEL_CPU" == "true" ]]; then
        echo -e "${RED}Error: AMD_CPU and INTEL_CPU are mutually exclusve and can't both be set to 'true'.${NC}"
        exit 1
    fi
}

function check_network() {
    ping -c 1 -i 2 -W 5 -w 30 $PING_HOSTNAME
    
    if [ $? -ne 0 ]; then
        echo "Error: Network ping check failed. Cannot continue."
        exit 1
    fi
}

function confirm_install() {
    clear

    echo -e "${LBLUE}Saki (Simple Arch KDE Installer)${NC}"
    echo ""
    echo -e "${RED}Warning"'!'"${NC}"
    echo -e "${RED}This script will destroy all data on ${HD_DEVICE}${NC}"
    echo ""

    echo -e "${LBLUE}HD Configuration:${NC}"
    print_variables_value "HD_DEVICE" "$HD_DEVICE"
    print_variables_boolean "TRIM_SUPPORT" "$TRIM_SUPPORT"
    print_variables_value "SWAPFILE_SIZE" "$SWAPFILE_SIZE"
    echo ""

    echo -e "${LBLUE}CPU Configuration:${NC}"
    print_variables_boolean "AMD_CPU" "$AMD_CPU"
    print_variables_boolean "INTEL_CPU" "$INTEL_CPU"
    echo ""

    echo -e "${LBLUE}GPU Configuration:${NC}"
    print_variables_boolean "AMD_GPU" "$AMD_GPU"
    print_variables_boolean "INTEL_GPU" "$INTEL_GPU"
    print_variables_boolean "NVIDIA_GPU" "$NVIDIA_GPU"
    echo ""

    echo -e "${LBLUE}Host Configuration:${NC}"
    print_variables_value "HOSTNAME" "$HOSTNAME"
    print_variables_value "TIMEZONE" "$TIMEZONE"
    print_variables_value "KEYS" "$KEYS"
    print_variables_value "LOCALE" "$LOCALE"
    print_variables_value "LANG" "$LANG"
    print_variables_value "REFLECTOR_COUNTRY" "$REFLECTOR_COUNTRY"
    echo ""

    echo -e "${LBLUE}User Configuration:${NC}"
    print_variables_value "ROOT_PASSWORD" "$ROOT_PASSWORD"
    print_variables_value "USER_NAME" "$USER_NAME"
    print_variables_value "USER_PASSWORD" "$USER_PASSWORD"
    echo ""

    echo -e "${LBLUE}Linux Command Line Params:${NC}"
    print_variables_value "CMDLINE_LINUX" "$CMDLINE_LINUX"
    echo ""

    read -p "Do you want to continue? [y/N] " yn
    case $yn in
        [Yy]* )
            ;;
        [Nn]* )
            exit
            ;;
        * )
            exit
            ;;
    esac
}

function install_aur_helper() {
    local COMMAND="rm -rf /home/$USER_NAME/.paru-makepkg && mkdir -p /home/$USER_NAME/.paru-makepkg && cd /home/$USER_NAME/.paru-makepkg && git clone https://aur.archlinux.org/paru.git && (cd paru && makepkg -si --noconfirm) && rm -rf /home/$USER_NAME/.paru-makepkg"
    exec_as_user "$COMMAND"
}

function exec_as_user() {
    local COMMAND="$1"
    arch-chroot /mnt sed -i 's/^%wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
    arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -s /usr/bin/bash -c \"$COMMAND\""
    arch-chroot /mnt sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL$/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
}

function configure_pacman_systemd_boot_hook() {	
    if [[ ! -d "/mnt/etc/pacman.d/hooks" ]]; then	
        arch-chroot /mnt mkdir -p /etc/pacman.d/hooks	
    fi	

    cat <<EOT > "/mnt/etc/pacman.d/hooks/sytemd-boot.hook"
[Trigger]
Type=Package
Operation=Upgrade
Target=systemd

[Action]
Description=Gracefully upgrading systemd-boot...
When=PostTransaction
Exec=/usr/bin/systemctl restart systemd-boot-update.service
EOT

}

function configure_pacman_mirrorupgrade_hook() {	
    if [[ ! -d "/mnt/etc/pacman.d/hooks" ]]; then	
        arch-chroot /mnt mkdir -p /etc/pacman.d/hooks	
    fi	

    cat <<EOT > "/mnt/etc/pacman.d/hooks/mirrorupgrade.hook"	
[Trigger]
Operation=Upgrade
Type=Package
Target=pacman-mirrorlist

[Action]
Description=Updating pacman-mirrorlist with reflector and removing pacnew...
When=PostTransaction
Depends=reflector
Exec=/bin/sh -c 'systemctl start reflector.service && rm -f /etc/pacman.d/mirrorlist.pacnew'
EOT

}

function configure_pacman_nvidia_hook() {
    if [[ ! -d "/mnt/etc/pacman.d/hooks" ]]; then
        arch-chroot /mnt mkdir -p /etc/pacman.d/hooks	
    fi

    cat <<EOT > "/mnt/etc/pacman.d/hooks/nvidia.hook"
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
EOT

}

function configure_sddm() {
    if [[ ! -d "/mnt/etc/sddm.conf.d" ]]; then
        arch-chroot /mnt mkdir -p /etc/sddm.conf.d
    fi

    cp /mnt/usr/lib/sddm/sddm.conf.d/default.conf /mnt/etc/sddm.conf.d/
    sed -i '$!N;s/# Current theme name\nCurrent=/# Current theme name\nCurrent=breeze/;P;D' /mnt/etc/sddm.conf.d/default.conf
}

# Console Colors
NC='\033[0m'

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

main "$@"
