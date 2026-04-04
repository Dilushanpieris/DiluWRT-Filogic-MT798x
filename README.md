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

