#!/bin/sh
# Beware! This script will be in /rom/etc/uci-defaults/ as part of the image.

root_password="dilu1212"
# Using CIDR notation required for OpenWrt 25.12+
lan_ip_address="192.168.3.1/24"

# log potential errors
exec >/tmp/setup.log 2>&1

# 1. Set Root Password
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# 2. Configure LAN IP
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# 3. Configure and Enable WLAN (2.4G / 5G)
# Enable the radios
uci set wireless.radio0.disabled='0'
uci set wireless.radio1.disabled='0'

# Set the custom SSID
uci set wireless.default_radio0.ssid='DiluWRT_2.4G/5G'
uci set wireless.default_radio1.ssid='DiluWRT_2.4G/5G'
uci commit wireless


# 4. Set Hostname
uci set system.@system[0].hostname='DiluWRT'
uci commit system

# 5. Apply Custom DiluWRT Banner
echo "Updating SSH login banner to DiluWRT..."
cat << 'EOF' > /etc/banner
8888888b.  d8b 888               888       888 8888888b. 88888888888 
888  "Y88b Y8P 888               888  o    888 888  "Y88b    888     
888    888     888               888 d8b   888 888    888    888     
888    888 888 888 888  888      888 d888b 888 888   d88P    888     
888    888 888 888 888  888      888d88888b888 8888888P"     888     
888    888 888 888 888  888      88888P Y88888 888 T88b      888     
888  .d88P 888 888 Y88b 888      8888P   Y8888 888  T88b     888     
8888888P"  888 888  "Y88888      888P     Y888 888   T88b    888
                            >NET. Limits Redefined.                                                                                                                                                                             
                                          
EOF

echo "Hostname and SSH banner updated successfully."
echo "Changes to hostname will take effect after a reboot."
echo "All done!"