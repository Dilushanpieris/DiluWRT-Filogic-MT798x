#!/bin/sh

# ------------------------------------------------------------------
# --- Configuration ---
# ------------------------------------------------------------------

# Theme Package (apk format)
THEME_URL="https://raw.githubusercontent.com/Dilushanpieris/DiluWRT-Filogic-MT798x/main/Argon%20Theme/luci-theme-argon-2.4.3-r20250722.apk"
THEME_NAME="luci-theme-argon-2.4.3-r20250722.apk"

# Background Image File
IMG_URL="https://raw.githubusercontent.com/Dilushanpieris/DiluWRT-Filogic-MT798x/main/Argon%20Theme/Imgs/MainPage.png"
IMG_NAME="MainPage.png"

# Directories
TMP_DIR="/tmp"
TOKEN_FILE="/etc/auth/.github_token"
ARGON_DIR="/www/luci-static/argon"
TARGET_DIR="$ARGON_DIR/background"

# ------------------------------------------------------------------
# --- Pre-Checks ---
# ------------------------------------------------------------------

if [ ! -f "$TOKEN_FILE" ]; then
    echo "Error: GitHub token not found at $TOKEN_FILE."
    echo "Please install your PAT first."
    exit 1
fi

AUTH_HEADER="Authorization: token $(cat "$TOKEN_FILE")"

# ------------------------------------------------------------------
# --- STEP 1: Install Argon Theme (.apk) ---
# ------------------------------------------------------------------
TEMP_PKG_PATH="$TMP_DIR/$THEME_NAME"

echo "--------------------------------------------------------"
echo "Downloading Argon Theme: $THEME_NAME"

# Download using wget and auth header
wget -O "$TEMP_PKG_PATH" --no-check-certificate --header="$AUTH_HEADER" "$THEME_URL"

if [ $? -eq 0 ]; then
    echo "Download successful. Installing via apk..."
    
    # Install the package using the new apk syntax for OpenWrt 25.12
    apk add --allow-untrusted "$TEMP_PKG_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Theme installation complete."
    else
        echo "Error: apk installation failed. Check dependencies."
        rm -f "$TEMP_PKG_PATH"
        exit 1
    fi
    # Cleanup
    rm -f "$TEMP_PKG_PATH"
else
    echo "Error: Download failed. Check URL and token."
    rm -f "$TEMP_PKG_PATH"
    exit 1
fi

# ------------------------------------------------------------------
# --- STEP 2: Install Background Image ---
# ------------------------------------------------------------------
echo "--------------------------------------------------------"
echo "Installing background image..."

# Verify Theme Directory exists before placing image
if [ ! -d "$ARGON_DIR" ]; then
    echo "Error: Argon theme directory not found at $ARGON_DIR."
    echo "Skipping background installation."
    exit 1
fi

# Create target directory and clear any existing default backgrounds
mkdir -p "$TARGET_DIR"
rm -f "$TARGET_DIR"/*

TEMP_IMG_PATH="$TMP_DIR/$IMG_NAME"
FINAL_IMG_PATH="$TARGET_DIR/$IMG_NAME"

echo "Downloading background image: $IMG_NAME"
wget -O "$TEMP_IMG_PATH" --no-check-certificate --header="$AUTH_HEADER" "$IMG_URL"

if [ $? -eq 0 ]; then
    # Move and set web permissions
    mv "$TEMP_IMG_PATH" "$FINAL_IMG_PATH"
    chmod 644 "$FINAL_IMG_PATH"
    echo "Background installed successfully."
else
    echo "Error: Background download failed."
    rm -f "$TEMP_IMG_PATH"
fi

# ------------------------------------------------------------------
# --- Conclusion ---
# ------------------------------------------------------------------
echo "--------------------------------------------------------"
echo "✅ Argon Theme setup is complete!"
echo "Background file installed at: $FINAL_IMG_PATH"
echo "Please reload LuCI and clear your browser cache to see it."
echo "--------------------------------------------------------"