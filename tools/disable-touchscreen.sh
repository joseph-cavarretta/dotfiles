#!/usr/bin/env bash
set -e

# Only root may run this
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo $0)"
  exit 1
fi

echo "🛠️  Updating package lists..."
apt-get update -qq

echo "📦  Ensuring required packages are installed..."
for pkg in xserver-xorg-input-libinput lm-sensors tlp; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    echo "  • Installing $pkg"
    apt-get install -y "$pkg"
  else
    echo "  • $pkg already installed"
  fi
done

echo "🧠  Disabling iio-sensor-proxy (tablet mode)..."
if systemctl is-active --quiet iio-sensor-proxy.service; then
  systemctl stop iio-sensor-proxy.service
else
  echo "  • iio-sensor-proxy.service already stopped"
fi
if systemctl is-enabled --quiet iio-sensor-proxy.service; then
  systemctl disable iio-sensor-proxy.service
else
  echo "  • iio-sensor-proxy.service already disabled"
fi

echo "🛑  Cleaning up touchscreen blacklist..."
BLACKLIST_FILE=/etc/modprobe.d/blacklist-tablet.conf
if grep -q 'hid_multitouch' "$BLACKLIST_FILE" 2>/dev/null; then
  sed -i '/hid_multitouch/d' "$BLACKLIST_FILE"
  echo "  • Removed hid_multitouch blacklist"
else
  echo "  • No hid_multitouch blacklist present"
fi

echo "⚙️   Rebuilding initramfs..."
update-initramfs -u

echo "📁  Disabling Wayland in GDM..."
GDM_CONF=/etc/gdm3/custom.conf
grep -q '^WaylandEnable=false' "$GDM_CONF" || {
  sed -i 's/^#\?\(WaylandEnable\)=.*/\1=false/' "$GDM_CONF"
  echo "  • Set WaylandEnable=false"
}

echo "📁  Writing libinput override for touchpad..."
XCONF_DIR=/etc/X11/xorg.conf.d
XCONF_FILE=$XCONF_DIR/40-libinput.conf
mkdir -p "$XCONF_DIR"
cat > "$XCONF_FILE" <<'EOF'
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
echo "  • Wrote $XCONF_FILE"

echo "📁  Creating udev rule to ignore touchscreen..."
UDEV_FILE=/etc/udev/rules.d/99-disable-touchscreen.rules
RULE='ATTRS{name}=="eGalax Inc. eGalaxTouch EXC3104-1324-07.00.00", ENV{LIBINPUT_IGNORE_DEVICE}="1"'
grep -qF "$RULE" "$UDEV_FILE" 2>/dev/null || {
  echo "$RULE" > "$UDEV_FILE"
  echo "  • Created $UDEV_FILE"
}

echo "⚡  Reloading udev rules..."
udevadm control --reload
udevadm trigger

echo "✅  disable-touchscreen.sh completed. Please reboot to apply all changes."

