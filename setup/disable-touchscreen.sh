#!/bin/bash

set -e

echo "🛠️  Updating system..."
apt update

echo "📦  Installing required packages..."
apt install -y xserver-xorg-input-libinput lm-sensors tlp

echo "🧠  Disabling iio-sensor-proxy (tablet mode)..."
systemctl stop iio-sensor-proxy.service || true
systemctl disable iio-sensor-proxy.service || true

echo "🛑  Removing touchscreen blacklist if present..."
sed -i '/hid_multitouch/d' /etc/modprobe.d/blacklist-tablet.conf 2>/dev/null || true

echo "⚙️   Updating initramfs..."
update-initramfs -u

echo "📁  Setting xorg as default (disable Wayland)..."
CONF=/etc/gdm3/custom.conf
if grep -q "^#WaylandEnable=" "$CONF"; then
    sed -i 's/^#WaylandEnable=/WaylandEnable=/' "$CONF"
fi
sed -i 's/^WaylandEnable=.*/WaylandEnable=false/' "$CONF"

echo "📁  Forcing libinput driver and enabling gestures..."
mkdir -p /etc/X11/xorg.conf.d
cat <<EOF > /etc/X11/xorg.conf.d/40-libinput.conf
Section "InputClass"
    Identifier "libinput touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "ScrollMethod" "twofinger"
EndSection
EOF

echo "📁  Adding udev rule to ignore touchscreen..."
cat <<EOF > /etc/udev/rules.d/99-disable-touchscreen.rules
ATTRS{name}=="eGalax Inc. eGalaxTouch EXC3104-1324-07.00.00", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

echo "⚡  Reloading udev..."
udevadm control --reload
udevadm trigger

echo "✅  Creating autostart entry to ensure two-finger scroll is enabled..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/touchpad-fix.desktop
[Desktop Entry]
Type=Application
Exec=xinput set-prop "DELL0808:00 06CB:7E92 Touchpad" "libinput Scroll Method Enabled" 0 1 0
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Enable 2-Finger Scroll
EOF

echo "🎉  All done! Please reboot to apply all changes."

