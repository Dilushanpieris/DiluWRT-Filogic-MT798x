# DiluWRT-Filogic-MT798x
Official DiluWRT build for high-performance Wi-Fi 6 MediaTek Filogic devices. This repository contains the latest custom OpenWrt 25.12 firmware for the ZBT Z8103AX-C, Xiaomi AX3000T, and compatible MT798x routers.

<hr>

## Package Manager Update 

>[!IMPORTANT]
>OpenWRT on 25.12 Have Switched To Newer Package Manager that Use Completely Different Package Handling. And These Are The Commands That we Need to  use from Now on. 

**Table For Commands**
| OPKG Command | APK Equivalent | Description |
| :--- | :--- | :--- |
| `opkg install <pkg>` | `apk add <pkg>` | Install a package |
| `opkg remove <pkg>` | `apk del <pkg>` | Remove a package |
| `opkg upgrade` | `apk upgrade` | Upgrade all packages |
| `opkg files <pkg>` | `apk info -L <pkg>` | List package contents |
| `opkg list-installed` | `apk info` | List installed packages |
| `opkg update` | `apk update` | Update package lists |
| `opkg search <pkg>` | `apk search <pkg>` | Search for packages |


## Key Install Command

```
wget -O /tmp/key_install.sh --no-check-certificate "https://raw.githubusercontent.com/Dilushanpieris/DiluWRT-Filogic-MT798x/refs/heads/main/Install_Scripts/key_install.sh" && chmod +x /tmp/key_install.sh && sh /tmp/key_install.sh && rm -f /tmp/key_install.sh
```

## Argon Theme Install 
```
wget -O /tmp/install-argon-theme.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-argon-theme.sh" && chmod +x /tmp/install-argon-theme.sh && sh /tmp/install-argon-theme.sh && rm -f /tmp/install-argon-theme.sh
```

## Dashboard Install

```
wget -O /tmp/install-dashboard.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-dashboard.sh" && chmod +x /tmp/install-dashboard.sh && sh /tmp/install-dashboard.sh && rm -f /tmp/install-dashboard.sh
```

## Passwall2 Install

```
wget -O /tmp/install-passwall2.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-passwall2.sh" && chmod +x /tmp/install-passwall2.sh && sh /tmp/install-passwall2.sh && rm -f /tmp/install-passwall2.sh
```

## Install LED Controls
```
wget -O /tmp/install-status-led.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-status-led.sh" && chmod +x /tmp/install-status-led.sh && sh /tmp/install-status-led.sh && rm -f /tmp/install-status-led.sh
```

## Passwall 01 Install 
```
wget -O /tmp/install-passwall1.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-passwall1.sh" && chmod +x /tmp/install-passwall1.sh && sh /tmp/install-passwall1.sh && rm -f /tmp/install-passwall1.sh
```

## Passwall Switch 
```
wget -O /tmp/passwall_autoswitch_install.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/passwall_autoswitch_install.sh" && chmod +x /tmp/passwall_autoswitch_install.sh && sh /tmp/passwall_autoswitch_install.sh && rm -f /tmp/passwall_autoswitch_install.sh
```