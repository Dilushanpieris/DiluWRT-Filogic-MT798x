# DiluWRT-Filogic-MT798x

<hr> 

Official DiluWRT build for high-performance Wi-Fi 6 MediaTek Filogic devices. This repository contains the latest custom OpenWrt 25.12 firmware for the ZBT Z8103AX-C, Xiaomi AX3000T, and compatible MT798x routers.

![Image DiluWRT](https://live.staticflickr.com/65535/54798242597_0201fcfbc4_b.jpg)

>[!TIP]
>This is Not A Free Ware like Build For S12 Pro You Need To Submit A Payment to Secure License to Use the Firmware -  DiluWRT 25.01

>[!CAUTION]
>Any Modding or Removing Verifiers May Result is Permanant Ban / Bootloop of Router That Cannot Be Recovered. Without a UART Flash. So Do Not Try To Remove Any Kind of Protection from router it's safety for both parties.

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


## 01 - Inital Setup - Basic Luci 

![First Boot](https://live.staticflickr.com/65535/54784179079_217072a029_b.jpg)

*After Reboot You Are Done with Flashing And Now You Can Log into Luci Interface With Following . SSH And WebUi both Enabled.*


**LUCI Interface** : http://192.168.2.1

**SSH Login/Default Login Luci (Can Change Later with Luci Interface)** <br>
* Username : root  
* password : dilu1212 (Default Password)

*You Can Update Password With Luci > System >Administration > Update Password (Same Password Updated for SSH And SCP)* 

**You Can Access Terminal All Inside of Luci .. Services > Terminal**


## 02 - Key Install 

>[!CAUTION]
>Before Requesting Key : <br>**Fully Read The Guideline From Start to End And Undersatnd The Process.** <br> **Installed DiluWRT Sysupgrade**<br> **Router Have Working Internet Connection when you pulg in Uplink to WAN**<br>
**Get Familier with The Process. You will be provided with a Key Along with your licencing** 

**Get Install Key and License From**

![WA Contact](https://live.staticflickr.com/65535/54953867207_c1c615b248.jpg)

**Paste this Command into your Terminal(Router Must Have Internet) It Will Upgrade Dependencies And Request For A Key Paste With ctrl + insert**

```
wget -O /tmp/key_install.sh --no-check-certificate "https://raw.githubusercontent.com/Dilushanpieris/DiluWRT-Filogic-MT798x/refs/heads/main/Install_Scripts/key_install.sh" && chmod +x /tmp/key_install.sh && sh /tmp/key_install.sh && rm -f /tmp/key_install.sh
```

>[!IMPORTANT]
>Now Your Router Is Ready for Full DiluWRT Install For MEdiatek MT987x Target Now You Can Paste Online Install Command. That Install all The Core of DiluWRT System. 

>[!WARNING]
>If plan to Install Passwall make Sure Free Space of minimum **68 MB** Is Avalible Before Flashing. **If Not Please Refer UbootMod And Re-partition Flash Storage without Recovery partition.**

## Online Install Command 

```
wget -O /tmp/oneline-install.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/oneline-Install.sh" && chmod +x /tmp/oneline-install.sh && sh /tmp/oneline-install.sh && rm -f /tmp/oneline-install.sh
```

>[!CAUTION]
> While Installing You Will Be Asked For **MAC Address/Interface**: <br>Please Select the Correct Interface Number. Same Mac Is Used in The **Box of Router/ Sticker on back** And Note That. This MAC Is Also Bound To your License And Selecting Wrong Interface/MAC Result in **SoftLock** So Please Be Cautious

**Also Ready to Press Button When Asked for Passwall Switch**

**Now Router Will Be Rebooted and Your Network May Work As Normal. Now For Passwall Install.**

![Theme Argon](https://live.staticflickr.com/65535/54783098247_548dfbcd4b_b.jpg)


## Passwall Install Commands

>[!IMPORTANT]
>This Is The Most Refined Version of Passwall02 Specifically for MI Ax3000T And ZBT Router models. From 31st of May Passwall Xray coare Has Error so Use old 25 Version if You Really Want To Stick to Xray Core otherwise You Can just use Latest one With Singbox Core.

**Passwall 02-25(2025/Dec) Minimal**

```
wget -O /tmp/install-passwall2-25.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-passwall2-25.sh" && chmod +x /tmp/install-passwall2-25.sh && sh /tmp/install-passwall2-25.sh && rm -f /tmp/install-passwall2-25.sh
```

**Passwall 02-Minimal(Singbox-only)**
```
wget -O /tmp/install-passwall2.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/install-passwall2.sh" && chmod +x /tmp/install-passwall2.sh && sh /tmp/install-passwall2.sh && rm -f /tmp/install-passwall2.sh
```

## Passwall Node/Routing Rule Mods

>[!WARNING]
>Proper Node Routing is Possible With Xray Core only, So If You Want To Configure Fallback/Backup Nodes Please Install Old Xray Core (Passwall 25). Multiple Nodes,Exclusions,URL Exclusions(Direct Lists) Can Be Configured Either With XrayCore Or Singbox Core. 

# XRAY CORE ROUTING CONFIGURATION

>[!TIP]
>By using an Xray Balancer Wrapper set to Fallback Mode, You Can Use Two Configs Main Config And The Backup Config to Make Your Router More Reliable to Server Side Drops.Its Only Possible From Xray Core Heres how We Setup Failover Nodes. 

**Implementaion - Failover Nodes**
1) Add Your Main Node And Secondry Node As Usual (Node List > Add Node Via Link)
2) Now Add New Node Using Add Button 
3) Configure As 
                Remarks : Give A Name As Failover/Backup Node
                Type : Xray
                Protocol : Balancing
                Add Main node As Load Balancing Node 
                Add Secondry node As Fallback Node (To Run if Main Node Failed)
                Balancing Stratergy : LeastPing
4) Now Save And Apply (Use Newly Created Node As Main Node in The Basic Settings Page)

>[!IMPORTANT]
>Shunt Is Just like A Switch For Passwall Nodes you Can Tie Node or Direct node With Custom Lists. Here Is How You Can Exclude Device With A Shunt Rule Of Direct And ACL

**Implementaion - Shunt Nodes**

1) Go No Node List And Add New Node
2) Configure New Node As <br>
                Remarks : Give Name As Shunt Direct<br>
                Type : Xray<br>
                Protocol : Shunt<br>
                Set Default + All Lists To Direct Connection<br>
3) Now You Can Setup Any Devices to Exclude Nodes With This Shunt



**Implementaion - ACL-Access Control for Devices**

1) Now Create New ACL Rule in The ACL Tab
2) ACL Rule Configure As :<br>
                Remarks :  LAN Direct<br>
                Source Interface : All<br>
                Source : Select your Mac<br>
                Node:   Select Shunt Rule For Fully Exclude Device from Node.<br>
                        Select Specific Node For Use That node For This Selected MAC/Device<br>
                Keep Rest As Default<br>
3) Save And Apply with Main witch ON (ACL)
            
**Implementaion - Exclusion-Domains**

1) Create New List on Rule Manage As Direct_list <br>
2) Add Domains in This Format(Toplevel/Individual)<br>

```
domain:lk
domain:dialog.lk
domain:slt.lk
geosite:category-ads-all
```
3) Now go to Node List And Create New Node Then Configure As :<br>
                Remarks : Give Name As Shunt Main<br>
                Type : Xray<br>
                Protocol : Shunt<br>
                Set Direct list to Direct Connection<br>
                Default to Your Failover/ Main Node <br>
                Save And Apply <br>

4) Now Use This Newly created Shunt Rule As your Main Node.

>[!IMPORTANT]
> You Can Combine These Routing Mechanisms To Implement for Ultimate Passwall Experience. With Failover Nodes + Each Node For Each Devices (MAC-Exclude) And Fully Excluded Devices With Shunt Rules. Also you Can Configure Rules (Lists) With your Custom Lists To Either Exclude Them From Passwall or Make them Route Through Specific Node. (Just Select Node you Want)


## Remove Passwall(Complete Uninstall)
>[!TIP]
>Now You Can Uninstall Passwall Using Below Command To Restore Memory And Try Installing Passwall Again.But Keep In Mind That Factory Reset of router is Always Much Better Than Soft uninstall of Passwall. 

```
wget -O /tmp/remove_passwall.sh --no-check-certificate --header="Authorization: token $(cat /etc/auth/.github_token)" "https://raw.githubusercontent.com/Dilushanpieris/Project-DiluWRT/refs/heads/main/DiluWRT-Filogic-Lib/Update%20Scripts/remove_passwall.sh" && chmod +x /tmp/remove_passwall.sh && sh /tmp/remove_passwall.sh && rm -f /tmp/remove_passwall.sh
```

## Auto Restart/Paswall-Switch On-Off using Crontab.

>[!IMPORTANT]
>Using Passwall without a Break Can Cause ISP To Tag your Router. So To Avoid limiting Speeds / Connection Drops its Highly Recommended to Have Auto restart Set up At Desired Time, Its Already Setup in The System > Scheduled Tasks if You Want to Avoid Any Automated Tasks. Use **#** In The Start of Command Looks like This . 

>[!TIP]
>To Make It Work please Make Sure The Correct Timezone is Set. 

**Navigate to Luci > System > Scheduled Tasks > Then Add **#** To Make automation Turn off**

```
# Reboot Router Everyday at 4.00 AM
# 0 4 * * * sleep 70 && touch /etc/banner && reboot     

# Start Passwall everyday at 8:00 AM
0 8 * * * /usr/share/autoswitch/pw_timer.sh start

# Stop Passwall everyday at 11:59 PM
59 23 * * * /usr/share/autoswitch/pw_timer.sh stop
```
*reboot will **not** Go off at 4.00 AM But Passwall will Start Everyday at 8.00 AM and Stop at 11.59 PM Where time is Synced.*

## Luci Mobile Management Interface

>[!TIP]
>This Is The Cleanest Management UI That You Can Find Just Download From Play Store And Log In Using Router Credentials.

**Play Store Link: [Luci_Mobile](https://play.google.com/store/apps/details?id=com.cogwheel.LuCIMobile&pli=1)**

## Acknolwlegements 

This project would not be possible without the hard work and dedication of the **OpenWrt community.** A special thank you goes to:

R1BNC: For the extensive video tutorials, guides, and inspiration regarding 4G/5G router modifications and OpenWrt customization.
The OpenWrt Community: To all the developers, maintainers, and builders who keep this open-source ecosystem alive and thriving.

Project-DiluWRT is built on the shoulders of giants. Thank you!

## Your Support is Much Appriciated:

<p><a href="https://www.buymeacoffee.com/dilu122x"> <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="dilu122x" /></a></p>