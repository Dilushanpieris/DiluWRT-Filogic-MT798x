#!/bin/sh

# ==========================================
# DiluWRT Full System Snapshot (Anti-Ghosting Restorer)
# ==========================================

SNAPSHOT_FILE="/etc/diluwrt_exact_point.tar.gz"

echo "-----------------------------------------------------"
echo " 1. Creating Full System Snapshot..."
echo "-----------------------------------------------------"
echo " Capturing all packages, themes, scripts, and configs..."

# Backup the entire read-write overlay, strictly excluding the backup file itself
tar -czpf "$SNAPSHOT_FILE" --exclude="*diluwrt_exact_point.tar.gz" -C /overlay/upper/ .

FILE_SIZE=$(du -h "$SNAPSHOT_FILE" | awk '{print $1}')
echo " ✅ Full Snapshot locked and stored! (Size: $FILE_SIZE)"

echo "-----------------------------------------------------"
echo " 2. Hijacking the OpenWrt Factory Reset System..."
echo "-----------------------------------------------------"

if [ ! -f "/sbin/firstboot_original" ]; then
    mv /sbin/firstboot /sbin/firstboot_original
fi

# Inject our RAM-staging restore logic into the hardware reset path
cat << 'EOF' > /sbin/firstboot
#!/bin/sh

while getopts "y" opt; do
  case $opt in
    y) ;;
  esac
done

echo "======================================" > /dev/console
echo " FACTORY RESET INTERCEPTED!" > /dev/console
echo " RESTORING EXACT POINT (ANTI-GHOSTING)..." > /dev/console
echo "======================================" > /dev/console

SNAPSHOT_FILE="/etc/diluwrt_exact_point.tar.gz"
RAM_STAGING="/tmp/exact_point_restore.tar.gz"

if [ -f "$SNAPSHOT_FILE" ]; then
    echo " -> 1/4 Moving snapshot to RAM..." > /dev/console
    cp "$SNAPSHOT_FILE" "$RAM_STAGING"
    
    echo " -> 2/4 Nuking current flash state (Destroying ghost files)..." > /dev/console
    # This deletes everything installed or changed after the ROM flash
    rm -rf /overlay/upper/*
    
    echo " -> 3/4 Extracting pure snapshot from RAM into Flash..." > /dev/console
    tar -xzpf "$RAM_STAGING" -C /overlay/upper/
    
    echo " -> 4/4 Restoring snapshot file for future resets..." > /dev/console
    cp "$RAM_STAGING" "/overlay/upper$SNAPSHOT_FILE"
    rm -f "$RAM_STAGING"
    
    echo " ✅ Exact Point Restore Complete. Rebooting now..." > /dev/console
    reboot
    exit 0
else
    echo " ❌ Snapshot missing! Failing gracefully." > /dev/console
    exit 1
fi
EOF

chmod +x /sbin/firstboot

echo "-----------------------------------------------------"
echo " ✅ NEW ANTI-GHOSTING RESET POINT SET!"
echo " Holding the reset button will now wipe the flash and"
echo " restore EVERYTHING strictly to this exact moment."
echo "-----------------------------------------------------"