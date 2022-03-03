#!/bin/bash
#|#./ingredients/hardware/amd-cpu_undervolt-support.sh #Support for undervolting AMD CPUs [Requires additional configuration]

DIR=$(dirname "$0")
source $DIR/../_helper/_common-functions.sh

paru -S --noconfirm --needed amdctl

# Create the systemd service
cat <<EOT > "amdctl.service"
[Unit]
Description=Undervolt cpu
After=sleep.target suspend.target hibernate.target hybrid-sleep.target
Requires=systemd-modules-load.target

[Service]
Type=simple
ExecStart=/usr/bin/amdctl-run.sh

[Install]
WantedBy=multi-user.target
WantedBy=sleep.target suspend.target hibernate.target hybrid-sleep.target
EOT

sudo mv amdctl.service /etc/systemd/system/.
sudo systemctl enable amdctl.service

# Create the script file that's excuted by the systemd service
cat <<EOT > "amdctl-run.sh"
#!/bin/sh
# Script to be executed by a systemd service to change voltage for AMD CPUs
# Run amdctl -g to get a current list of CpuVids for each Pstate.  Increasing the CpuVid value will decrease the voltage
#
# Example for AMD Ryzen 4800U:
# ~> amdctl -g
#Core 0 | P-State Limits (non-turbo): Highest: 0 ; Lowest 2 | Current P-State: 0
# Pstate Status CpuFid CpuDid CpuVid CpuMult CpuFreq CpuVolt IddVal IddDiv CpuCurr CpuPower
#      0      1     90     10     53  18.00x 1800MHz  1219mV     18     10  28.00A   34.12W
#      1      1    102     12     96  17.00x 1700MHz   950mV     17     10  27.00A   25.65W
#      2      1     98     14    102  14.00x 1400MHz   912mV     14     10  24.00A   21.90W
#
# CpuVids are:
# Pstate 0: 53 (fastest)
# Pstate 1: 96
# Pstate 2: 102 (slowest)
#
# Generally increasing Pstate CpuVids by 10 is quite safe.  In this example we would increase each CpuVid by 10:
#
# /usr/bin/amdctl -p 0 -v 63
# /usr/bin/amdctl -p 1 -v 106
# /usr/bin/amdctl -p 2 -v 112
EOT

sudo mv amdctl-run.sh /usr/bin/.
sudo chmod +x /usr/bin/amdctl-run.sh

# Make sure msr kernel module gets loaded at boot time
if [[ ! -d "/etc/modules-load.d" ]]; then
    sudo mkdir /etc/modules-load.d
fi

echo "msr" | sudo tee /etc/modules-load.d/amdctl.conf

echo -e "${YELLOW}Warning: to properly enable undervolting you will need to:"
echo -e "1. Add 'msr.allow_writes=on' to GRUB_CMDLINE_LINUX in /etc/grub/default"
echo -e "2. Run 'grub-mkconfig -o /boot/grub/grub.cfg'"
echo -e "3. Update /usr/bin/amdctl-run.sh with the appropriate CpuVid values to perform undervolt${NC}"
