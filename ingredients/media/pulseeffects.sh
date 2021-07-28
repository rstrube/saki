#!/bin/bash
#|#./ingredients/media/pulseeffects.sh #PulseEffects + Perfect EQ

paru -S --noconfirm --needed pulseeffects
mkdir -p ~/.config/PulseEffects/output
cp ./_supporting/Perfect-EQ.json ~/.config/PulseEffects/output/