#!/bin/sh
# Located in /etc/uci-defaults/ inside your custom Xiaomi AX3000T image build

root_password="dilu1212"
lan_ip_address="192.168.2.1/24"
wlan_name="DiluWRT_2.4G/5G_AX3000"

# Log potential errors silently
exec >/tmp/setup.log 2>&1

# 1. Set Root Password
if [ -n "$root_password" ]; then
    (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# 2. Configure LAN (Strictly using official reference pattern)
if [ -n "$lan_ip_address" ]; then
    uci set network.lan.ipaddr="$lan_ip_address"
    uci commit network
fi

# 3. Configure WLAN & Country Codes (Strictly using official reference array indices)
if [ -n "$wlan_name" ]; then
    # Set Regulatory Domain to US for both physical radios
    uci set wireless.@wifi-device[0].country='US'
    uci set wireless.@wifi-device[1].country='US'

    # Turn on both dual-band radios
    uci set wireless.@wifi-device[0].disabled='0'
    uci set wireless.@wifi-device[1].disabled='0'
    
    # Wireless Interfaces (Map SSIDs to both radio tracks)
    uci set wireless.@wifi-iface[0].disabled='0'
    uci set wireless.@wifi-iface[0].ssid="$wlan_name"
    
    uci set wireless.@wifi-iface[1].disabled='0'
    uci set wireless.@wifi-iface[1].ssid="$wlan_name"
    
    uci commit wireless
fi

# 4. Configure System Hostname, Regional Targets, and Metadata
uci set system.@system[0].hostname='DiluWRT'
uci set system.@system[0].zonename='Asia/Colombo'
uci set system.@system[0].timezone='IST-5:30'
uci set system.@system[0].description='Official Diluwrt Build Optimized For Xiaomi AX3000T'
uci set system.@system[0].notes='# Default Root password : dilu1212
 # Passwall Auto Switch Is Enabled by Default 
 # Do Not Try To Tamper With License guard.
 # Please Do Not Reset Router (You May Loose Configs)
 # Dev Contact +94762358660'
uci commit system

# 5. Apply Custom DiluWRT Banner
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

# 6. Signal Completion safely (No power-cut reboot loops)
echo "All done!"